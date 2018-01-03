require "redcarpet"
require "pygments"
require_relative "../helpers"


class Redcarpet::Render::HTML
    def header(title, level)
        anchor = Helpers.clean(title)

        return <<-eos
            <h#{level}>
                <a class="header-anchor"
                    name="#{anchor}"
                    aria-hidden="true"
                    href="##{anchor}"><i class="fa fa-link"></i></a>
                #{title}
            </h#{level}>
        eos
    end
    # Hacks to get markdown working inside html blocks ....
    def block_html(html)
        html.gsub(/<markdown>([\d\D]+?)<\/markdown>/) {|_|
            extensions = {fenced_code_blocks: true}
            renderer = Redcarpet::Markdown.new(WithHighlights, extensions)
            renderer.render(Regexp.last_match[1])
        }
    end

    def link(link, title, content)
        if link == "unfinished-article"
            return <<-eos
            <div class="info-box">
                本文部分或完全未完成。
               欢迎大家来创建 <a href="https://github.com/petkaantonov/bluebird/edit/master/docs/docs/#{content}.md">pull 请求</a>
                来帮助完成这篇文章。
            </div>
            eos
        elsif link == "."
            if content =~ /#\d+/
                url = "https://github.com/petkaantonov/bluebird/issues/" + content[1..-1]
            else
                url = "/bluebird_cn/docs/api/" + Helpers.clean(content) + ".html"
            end
            return "<a href='#{url}'><code>#{content}</code></a>"
        else
            return "<a href='#{link}' title='#{title}'>#{content}</a>"
        end
    end
end

class WithHighlights < Redcarpet::Render::HTML
    def block_code(code, language)
        Pygments.highlight(code, :lexer => language)
    end
end
