#!/usr/bin/env ruby
# compress all but the latest log files
# run from cron daily
#
# MANAGED BY PUPPET. DO NOT MODIFY LOCALLY


def rotate(dir)
  logs = Dir.glob("#{dir}/*.*")

  # select uncompressed log files
  logs = logs.select { |f| f =~ /\.[0-9]{14}$/ }

  # group logs to domains
  groups = {}
  logs.each do |f|
    head = f[0...-15];
    g = groups[head];
    if !g then
      g = groups[head] = [];
    end
    g << f;
    # puts "#{head}\t#{f}";
  end

  groups.each do |k, v|
    puts k;
    v = v.sort();
    v[0...-1].each do |f|
      puts "  Compressing #{f}";
      system "gzip #{f}";
    end
    puts "  Preserving  #{v[-1]}";
  end
end

# First rotate everything in our directory
rotate(".")

# The rotate all our subdirectories
Dir.glob('*').select do |f|
  if File.directory?(f)
    rotate(f)
  end
end
