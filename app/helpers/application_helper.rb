module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def title_image(image_url)
    content_for(:title_image) { image_url }
  end

	def current_url
		"#{request.protocol}#{request.host_with_port}#{request.fullpath}"
	end

	def full_url(path)
		"#{request.protocol}#{request.host_with_port}#{path}"
	end

	def google_translate_url(text)
		index = I18n.available_locales.index(I18n.locale)
		from_locale = :en
		# locale found in first spot and there is only 1 locale
		if index == 0 && I18n.available_locales.length == 1
			from_locale = I18n.locale
		# locale found in first spot, get locale in 2nd spot
		elsif index == 0 && I18n.available_locales.length > 1
			from_locale = I18n.available_locales[1]
		# locale found not in first spot, get locale in first spot
		elsif index > 0
			from_locale = I18n.available_locales[0]
		end

		"http://translate.google.com/##{from_locale}/#{I18n.locale}/#{text.html_safe}"
	end

	def flash_translation(level)
    case level
    when :notice then "alert-info"
    when :success then "alert-success"
    when :error then "alert-error"
    when :alert then "alert-error"
    end
  end

	# from http://www.kensodev.com/2012/03/06/better-simple_format-for-rails-3-x-projects/
	# same as simple_format except it does not wrap all text in p tags
	def simple_format_no_tags(text, html_options = {}, options = {})
		text = '' if text.nil?
		text = smart_truncate(text, options[:truncate]) if options[:truncate].present?
		text = sanitize(text) unless options[:sanitize] == false
		text = text.to_str
		text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
#		text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
		text.html_safe
	end


	# Based on https://gist.github.com/1182136
  class BootstrapLinkRenderer < ::WillPaginate::ActionView::LinkRenderer
    protected

    def html_container(html)
      tag :div, tag(:ul, html), container_attributes
    end

    def page_number(page)
      tag :li, link(page, page, :rel => rel_value(page)), :class => ('active' if page == current_page)
    end

    def gap
      tag :li, link(super, '#'), :class => 'disabled'
    end

    def previous_or_next_page(page, text, classname)
      tag :li, link(text, page || '#'), :class => [classname[0..3], classname, ('disabled' unless page)].join(' ')
    end
  end

  def page_navigation_links(pages)
    will_paginate(pages, :class => 'pagination', :inner_window => 2, :outer_window => 0, :renderer => BootstrapLinkRenderer, :previous_label => '&larr;'.html_safe, :next_label => '&rarr;'.html_safe)
  end
end
