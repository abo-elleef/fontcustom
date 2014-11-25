require "spec_helper"
require "fontcustom/cli"

describe Fontcustom::CLI do
  context "#compile" do
    it "should generate fonts and templates (integration)", :integration => true do
      live_test do |testdir|
        Fontcustom::CLI.start ["compile", "vectors", "--quiet"]
        manifest = File.join testdir, ".fontcustom-manifest.json"
        preview = File.join testdir, "fontcustom", "fontcustom-preview.html"

        expect(Dir.glob(File.join(testdir, "fontcustom", "fontcustom_*\.{ttf,svg,woff,eot}")).length).to eq(4)
        expect(File.read(manifest)).to match(/"fonts":.+fontcustom\/fontcustom_.+\.ttf"/m)
        expect(File.exists?(preview)).to be_truthy
      end
    end

    it "should generate fonts and templates according to passed options (integration)", :integration => true do
      live_test do |testdir|
        Fontcustom::CLI.start ["compile", "vectors", "--font-name", "example", "--no-hash", "--base64", "--quiet"]
        manifest = File.join testdir, ".fontcustom-manifest.json"
        css = Dir.glob(File.join("example", "*.css")).first

        expect(File.read(manifest)).to match(/"fonts":.+example\/example\.ttf"/m)
        expect(File.read(css)).to match("x-font-woff")
      end
    end
  end
end
