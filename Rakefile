PROJECT_NAME = "PDFreeBase"
CONFIGURATION = "Release"
UI_SPECS_TARGET_NAME = "Specs"

SDK_VERSION = "6.1"
PROJECT_ROOT = File.dirname(__FILE__)
BUILD_DIR = File.join(PROJECT_ROOT, "build")

def sdk_dir
  "#{xcode_developer_dir}/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator#{SDK_VERSION}.sdk"
end

# Xcode 4.3 stores its /Developer inside /Applications/Xcode.app, Xcode 4.2 stored it in /Developer
def xcode_developer_dir
  `xcode-select -print-path`.strip
end

def build_dir(effective_platform_name)
  File.join(BUILD_DIR, CONFIGURATION + effective_platform_name)
end

def system_or_exit(cmd, stdout = nil)
  puts "Executing #{cmd}"
  cmd += " >#{stdout}" if stdout
  system(cmd) or raise "******** Build failed ********"
end

def with_env_vars(env_vars)
  old_values = {}
  env_vars.each do |key,new_value|
    old_values[key] = ENV[key]
    ENV[key] = new_value
  end

  yield

  env_vars.each_key do |key|
    ENV[key] = old_values[key]
  end
end

def output_file(target)
  output_dir = if ENV['IS_CI_BOX']
    ENV['CC_BUILD_ARTIFACTS']
  else
    Dir.mkdir(BUILD_DIR) unless File.exists?(BUILD_DIR)
    BUILD_DIR
  end

  output_file = File.join(output_dir, "#{target}.output")
  puts "Output: #{output_file}"
  output_file
end

def kill_simulator
  system %Q[killall -m -KILL "gdb"]
  system %Q[killall -m -KILL "otest"]
  system %Q[killall -m -KILL "iPhone Simulator"]
end

task :default => [:trim, :uispecs]

desc "Trim whitespace"
task :trim do
  filenames = `git status --short | grep --invert-match ^D | cut -c 4-`.split("\n")
  filenames.map! do |filename|
    if filename.include?('->')
      filename = filename.slice(filename.index("->")..-1)
      filename.gsub!('-> ', '')
    end
    filename
  end
  system_or_exit %Q[echo '#{filenames.join("\n")}'| grep -E '.*\.m?[cmhn]\"?$' | xargs sed -i '' -e 's/    /    /g;s/ *$//g;']
end

desc "Remove any focus from specs"
task :nof do
  system_or_exit %Q[ grep -l -r -e "\\(fit\\|fdescribe\\|fcontext\\)" Specs | grep -v 'Specs/Frameworks' | xargs -I{} sed -i '' -e 's/fit\(@/it\(@/g;' -e 's/fdescribe\(@/describe\(@/g;' -e 's/fcontext\(@/context\(@/g;' "{}" ]
end

desc "Clean all targets"
task :clean do
  system_or_exit "rm -rf #{BUILD_DIR}/*", output_file("clean")
end

desc "Build UI specs"
task :build_uispecs do
  kill_simulator
  system_or_exit "set -o pipefail; xcodebuild -project #{PROJECT_NAME}.xcodeproj -target #{UI_SPECS_TARGET_NAME} -configuration #{CONFIGURATION} -sdk iphonesimulator build 2>&1 | grep -v xcactivitylog", output_file("uispecs")
end

require 'tmpdir'

desc "Run UI specs"
task :uispecs => :build_uispecs do
  env_vars = {
    "CEDAR_HEADLESS_SPECS" => "1",
    "CEDAR_REPORTER_CLASS" => "CDRColorizedReporter",
  }

  with_env_vars(env_vars) do
	system_or_exit "./bin/ios-sim launch #{File.join(build_dir("-iphonesimulator"), "#{UI_SPECS_TARGET_NAME}.app")} 2>&1 | grep -v BKSetAccelerometerClientEventsEnabled";
  end
end
