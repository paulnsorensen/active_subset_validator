module ActiveSubsetValidator
  class Railtie < Rails::Railtie
    initializer 'active_subset_validator' do
      ActiveSupport.on_load :active_record do
        include ActiveSubsetValidator
      end
    end
  end
end