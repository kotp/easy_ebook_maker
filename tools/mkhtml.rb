# mkhtml.rb
require 'BlueCloth'
PATH = 'http://github.com/ashbb/easy_ebook_maker/tree/master'

b = BlueCloth.new IO.read('../README.md')
b.gsub!("(#{PATH}/md/", '(../html/')
b.gsub!('.md)', '.html)')
open('../html/index.html', 'w'){|f| f.puts b.to_html}

style_css = IO.read('./style.css')

Dir.glob("../md/*.md").each do |mfile|
  lines = IO.readlines mfile
  hfile = '../html/' + mfile.split('/').last.sub('.md', '.html')
  open(hfile, 'w') do |f|
    lines.each do |line|
      if line[0, 2] == '!['
        fname = /^\!\[(.*)\]/.match(line).to_a[1]
        line = "![#{fname}](../img/#{fname})"
      end
      f.puts line
    end
  end
  b = BlueCloth.new IO.read(hfile)
  open(hfile, 'w'){|f| f.puts style_css, b.to_html.gsub(/<code>/, '<code class="ruby">')}
end
