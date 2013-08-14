module ActiveSubsetValidator
  class Railtie < Rails::Railtie
    initializer 'active_subset_validator.subset_validator' do
      ActiveSupport.on_load :active_record do
        extend SubsetValidator
      end
    end
  end
end