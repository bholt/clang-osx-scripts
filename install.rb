#!/usr/bin/env ruby
require 'FileUtils'; include FileUtils

install_prefix = ARGV[0]

clang_exe = File.readlink("#{install_prefix}/bin/clang")

m = {}

m['clang'] = <<-SH#!/bin/bash
exec #{clang_exe} -isystem /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -L/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib -I/usr/local/include -Qunused-arguments "$@"
SH

m['clang++'] = <<-SH#!/bin/bash
exec #{clang_exe} -stdlib=libc++ -nostdinc++ -isystem /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../lib/c++/v1 -isystem /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -L/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib -I/usr/local/include -lc++ -Qunused-arguments "$@"
SH

m.each do |exe,text|
  target = "#{install_prefix}/bin/#{exe}"
  rm(target) # currently a symlink
  
  open(target,"w"){|f| f.write(text) }
  
  chmod("+x", target)
end
