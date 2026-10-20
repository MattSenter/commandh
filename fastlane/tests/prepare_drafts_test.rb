# Offline behavior checks; no credentials or network needed.
require 'ostruct'
# Offline fixtures must never appear as real App Store results in CI.
ENV.delete('GITHUB_STEP_SUMMARY')
def default_platform(*) ; end
def desc(*) ; end
def app_store_connect_api_key(*) ; {} ; end
def platform(*) ; yield ; end
def private_lane(*) ; end
def lane(name, &block) ; (@lanes ||= {})[name] = block ; end
module UI
  def self.user_error!(message) ; raise message ; end
  def self.success(*) ; end
  def self.message(*) ; end
end
module Spaceship
  module ConnectAPI
    class << self; attr_accessor :token; end
    class Token
      def self.from(hash:) ; hash ; end
    end
    class App
      def self.find(*) ; $app ; end
    end
    class Build
      def self.all(**options)
        $lookups << options
        $builds.fetch(options[:platform], [])
      end
    end
  end
end
class Draft
  attr_accessor :version_string, :app_store_state, :selected
  def initialize(version)
    @version_string = version
    @app_store_state = 'PREPARE_FOR_SUBMISSION'
  end
  def select_build(build_id:) ; @selected = build_id ; end
  def get_build ; OpenStruct.new(id: @selected) ; end
end
class App
  def id ; '123' ; end
  def get_live_app_store_version(platform:) ; OpenStruct.new(version_string: '1.19') ; end
  def get_in_review_app_store_version(platform:) ; $reviews[platform] ; end
  def get_edit_app_store_version(platform:) ; $drafts[platform] ; end
end
def upload_to_app_store(**options)
  $uploads << options
  platform = options[:platform] == 'ios' ? 'IOS' : 'MAC_OS'
  $drafts[platform] ||= Draft.new(options[:app_version]) unless $fail_readback
end
def reset
  $app = App.new
  $uploads = []; $lookups = []; $drafts = {}; $builds = {}; $reviews = {}; $fail_readback = false
end
def check(condition, message)
  raise message unless condition
end
def fails_with(fragment)
  begin
    yield
  rescue => error
    raise unless error.message.include?(fragment)
    return
  end
  raise "Expected failure containing #{fragment}"
end
METADATA_PATH = File.expand_path('../metadata', __dir__)
SCREENSHOTS_PATH = File.expand_path('../screenshots', __dir__)
BUNDLE_ID = 'com.mattsenter.CommandH'
def asc_api_key; {}; end
def listing_assets?(*); true; end
def check_listing_copy!; end
def find_app!(*); $app; end
source = File.read(File.expand_path('../Fastfile', __dir__))
start = source.index('  desc "Prepare an editable')
finish = source.index('  desc "Upload the screenshots', start)
eval(source[start...finish], binding, 'Fastfile')
prepare = @lanes.fetch(:prepare_drafts)
reset
prepare.call(version: '1.30')
check($uploads.map { |o| o[:platform] } == %w[osx], 'macOS platform required')
check($uploads.all? { |o| o[:metadata_path] == METADATA_PATH && o[:overwrite_screenshots] }, 'Listing paths missing')
$uploads.each do |o|
  %i[submit_for_review automatic_release edit_live use_live_version skip_metadata skip_screenshots].each do |key|
    check(o[key] == false, "Unsafe option #{key}")
  end
  check(o[:skip_binary_upload] && o[:force], 'Must upload noninteractively without a build')
  check(o[:app_version] == '1.30', 'Wrong marketing version')
  folder = 'screenshots'
  check(o[:screenshots_path].end_with?(folder), 'Wrong platform screenshots')
end
check($lookups.all? { |o| o[:version] == '1.30' && o[:processing_states] == 'VALID' }, 'Build search must match version and processing state')
# Reruns refresh the same drafts and attach independent platform builds.
%w[MAC_OS].each do |platform|
  $builds[platform] = [OpenStruct.new(id: 'expired', expired: true), OpenStruct.new(id: platform, version: '123', expired: false)]
end
prepare.call(version: '1.30')
check($drafts.all? { |platform, draft| draft.selected == platform }, 'Platform-specific build attachment failed')
reset
prepare.call(version: '1.30', attach_builds: false)
check($lookups.empty?, 'Disabled attachment queried builds')
['', 'v1.30', '1..30', '1.30;echo test'].each do |version|
  reset
  fails_with('Pass version') { prepare.call(version: version) }
  check($uploads.empty?, 'Invalid version mutated listings')
end
reset
fails_with('attach_builds must') { prepare.call(version: '1.30', attach_builds: 'maybe') }
reset
fails_with('must be newer') { prepare.call(version: '1.19') }
check($uploads.empty?, 'Live version mutated')
reset
$drafts['MAC_OS'] = Draft.new('1.29')
fails_with('leaving it untouched') { prepare.call(version: '1.30') }
check($uploads.empty?, 'Preflight must check both platforms before writing')
reset
$drafts['MAC_OS'] = Draft.new('1.30')
$drafts['MAC_OS'].app_store_state = 'WAITING_FOR_REVIEW'
fails_with('leaving it untouched') { prepare.call(version: '1.30') }
reset
$reviews['MAC_OS'] = true
fails_with('already in review') { prepare.call(version: '1.30') }
check($uploads.empty?, 'Reviewing app mutated')
reset
$fail_readback = true
fails_with('not read back') { prepare.call(version: '1.30') }
puts 'PASS: macOS drafts, reruns, matching builds, no-build and opt-out paths, input validation, live/draft/review guards, readback failure'
