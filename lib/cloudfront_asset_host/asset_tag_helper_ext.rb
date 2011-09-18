module ActionView
  module Helpers
    module AssetTagHelper
      class AssetPaths
        private

        # Override asset_id so it calculates the key by md5 instead of modified-time
        def rails_asset_id_with_cloudfront(source)
          if self.cache_asset_ids && (asset_id = self.asset_ids_cache[source])
            asset_id
          else
            path = File.join(config.assets_dir, source)
            rewrite_path = File.exist?(path) && !CloudfrontAssetHost.disable_cdn_for_source?(source)
            asset_id = rewrite_path ? CloudfrontAssetHost.key_for_path(path) : ''

            if self.cache_asset_ids
              add_to_asset_ids_cache(source, asset_id)
            end

            asset_id
          end
        end

        # Override asset_path so it prepends the asset_id
        def rewrite_asset_path_with_cloudfront(source, path=nil)
          asset_id = rails_asset_id(source)
          if asset_id.blank?
            source
          else
            "/#{asset_id}#{source}"
          end
        end
      end
    end
  end
end
