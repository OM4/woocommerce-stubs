<?php

return \StubsGenerator\Finder::create()
    ->in('woocommerce/includes')
    ->append(
        \StubsGenerator\Finder::create()
            ->in(['woocommerce/lib'])
            ->files()
    )
    ->append(
        \StubsGenerator\Finder::create()
            ->in(['woocommerce'])
            ->files()
            ->depth('< 1')
            ->path('woocommerce.php')
    )
    ->append(
        \StubsGenerator\Finder::create()
            ->in(['woocommerce/src'])
            ->files()
            ->sortByName(true)
    )
    // Exclude woocommerce.com API as is uses the woocommerce-rest-api package.
    ->notPath('wccom-site/rest-api/endpoints')
    // Exclude WP-CLI command as is extends Plugin_Command.
    ->notPath('cli/class-wc-cli-com-extension-command.php')
    // Templates.
    ->notPath('admin/views')
    ->notPath('admin/helper/views')
    ->notPath('admin/importers/views')
    ->notPath('admin/marketplace-suggestions/templates')
    ->notPath('admin/marketplace-suggestions/views')
    ->notPath('admin/meta-boxes/views')
    ->notPath('admin/plugin-updates/views')
    ->notPath('admin/settings/views')
    // $ ls includes/shipping/*/includes/*.php
    ->notPath('shipping/flat-rate/includes/settings-flat-rate.php')
    ->notPath('shipping/legacy-flat-rate/includes/settings-flat-rate.php')
    // Legacy WooCommerce API.
    ->notPath('api/legacy')
    ->notPath('legacy/api')
    // Update functions.
    ->notPath('wc-update-functions.php')
    ->sortByName(true);
