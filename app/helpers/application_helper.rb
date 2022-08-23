module ApplicationHelper
  include Pagy::Frontend
  # Returns the full title on a per-page basis.
  def full_title page_title = ""
    page_title.blank? ? t("base_title") : "#{page_title} | #{t('base_title')}"
  end

  def current_translations
    @translations ||= I18n.backend.send(:translations)
    @translations[I18n.locale].with_indifferent_access
  end
end
