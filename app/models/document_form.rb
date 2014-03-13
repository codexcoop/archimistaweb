class DocumentForm < ActiveRecord::Base

  has_many :document_form_editors
  has_many :rel_fond_document_forms
  has_many :fonds, :through => :rel_fond_document_forms

end

