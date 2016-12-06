#! ruby
# encoding: utf-8

require 'base64'

if ARGV.size == 0
  images = Dir.glob("*")
else
  images = ARGV
end

IMAGE_WIDTH = 32
IMAGE_HEIGHT = 16
TEXT_SPACE = 6

def screen?
  ENV['TERM'] == 'screen' ||
  ENV['TERM'] == 'xscreen'
end

def cursor_move_up(n)
  print "\033[#{n}A"
end

def cursor_move_down(n)
  print "\033[#{n}B"
end

def cursor_move_right(n)
  print "\033[#{n}C"
end

def cursor_move_left(n)
  print "\033[#{n}D"
end

def print_osc
  if screen?
    print "\033Ptmux;\033\033]"
  else
    print "\033]"
  end
end

def print_st
  if screen?
    print "\a\033\\"
  else
    print "\a"
  end
end

def show_img(fn, width, height)
  print_osc
  print "1337;File=name=#{Base64.encode64(fn)};"
  print "inline=1;height=#{height};width=#{width};preserveAspectRatio=1:"
  print Base64.encode64( open(fn, 'rb') { |f| f.read } )
  print_st
end

def show_first_cell(fn, width, height)
  print fn[0, width - TEXT_SPACE].center(width)
  cursor_move_left(width)

  puts

  show_img fn, width, height
end

def show_cell(fn, width, height)
  print fn[0, width - TEXT_SPACE].center(width)
  cursor_move_left(width)

  cursor_move_down(1)

  show_img fn, width, height
end

cols = `tput cols`.to_i
imgs_col = (cols / IMAGE_WIDTH) - 1

images
  .select {|fn| /\.(jpeg|jpg|png|gif|bmp)$/i =~ fn }
  .each_slice(imgs_col) do |fst, *fns|
    show_first_cell(fst, IMAGE_WIDTH, IMAGE_HEIGHT)
    fns.each do |fn|
      cursor_move_up(16)
      show_cell(fn, IMAGE_WIDTH, IMAGE_HEIGHT)
    end
    2.times { puts }
  end
