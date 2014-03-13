class SiteController < ApplicationController

  def index
    @fonds_count = Fond.count
    @creators_count = Creator.count
    @custodians_count = Custodian.count
    
    @fonds = Fond.roots.order("name").limit(5)
    @creators = Creator.list.order("name").limit(5)
    @custodians = Custodian.list.order("name").limit(5)
  end

end

