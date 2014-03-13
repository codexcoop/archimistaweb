class SearchController < ApplicationController

  def index
    begin
      starting = Integer(params[:start]) rescue 0
      ending   = Integer(params[:end])   rescue 0

      with = {}
      with[:start_year] = starting..DateTime.now.year unless starting.zero?
      with[:end_year] = 0..ending unless ending.zero?
      with[:root_fond_id] = params[:root_fond_id] unless params[:root_fond_id].blank?

      without = {}
      without[:digital_object_id ] = 0 if params[:dob].to_i == 1

      scopes = [Fond, Unit, Creator, Custodian]
      counts_by_scopes(scopes, with, without)

      scopes.delete_if {|x| x != params[:scope].camelize.constantize } if params[:scope].present?

      params[:sort] ||= 'relevance'
      order = params[:sort] == 'relevance' ? '@relevance DESC' : 'order_date ASC'

      @results = ThinkingSphinx.search(params[:q].downcase,
        :with => with,
        :without => without,
        :include => [:first_digital_object, :preferred_name, :preferred_event],
        :page => params[:page],
        :per_page => 20,
        :field_weights => {
          :display_name  => 5,
          :content => 3,
        },
        :excerpts => true,
        :excerpt_options => {
          :before_match    => '<b>',
          :after_match     => '</b>',
          :chunk_separator => ' &#8230; ',
          :limit_words => 100
        },
        :match_mode => :extended,
        :sort_mode => :extended,
        :order => order,
        :classes => scopes)

      if scopes.include?(Unit)
        @facets = Unit.facets(params[:q].downcase, :with => with.reject{|k, v| k == :root_fond_id}, :without => without)
        @facets = @facets[:root_fond_id].sort_by{|a| a[1]}.reverse
        if @facets.size > 20
          @other_facets = @facets.slice(20, @facets.size - 1)
          @facets = @facets.slice(0, 19)
        end
      end

      paths_of(@results)

    end
  rescue
    ThinkingSphinx::SphinxError
  end

  private

  def counts_by_scopes(scopes, with, without)
    @counts = ActiveSupport::OrderedHash.new
    scopes.each do |klass|
      facet = klass.facets(params[:q].downcase, :class_facet => true, :with => with, :without => without)
      @counts[klass.name.downcase.pluralize] = Integer(facet[:class][klass.to_s]) rescue 0
    end
  end

  def paths_of(results)
    @paths = {}
    results.each do |result|
      path = []
      case result.class.name.downcase
      when 'unit'
        unless @paths.has_key?(result.fond_id)
          result.fond.path_items.each do |fond|
            path << fond.name
          end
          @paths[result.fond_id] = path.join(' / ')
        end
      when 'fond'
        unless @paths.has_key?(result.id)
          result.path_items.each do |fond|
            path << fond.name
          end
          @paths[result.id] = path.join(' / ')
        end
      end
    end
  end

end