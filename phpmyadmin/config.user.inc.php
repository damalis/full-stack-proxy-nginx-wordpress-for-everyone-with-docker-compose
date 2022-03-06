<?php

/* We now have to tell phpMyAdmin that SSL must be used whenever a connection is made. */
$cfg['ForceSSL'] = true;

/* Uploads setup */
$cfg['UploadDir'] = $_ENV['PMA_APACHE2_PREFIX'] . '/../upload';
$cfg['SaveDir'] = $_ENV['PMA_APACHE2_PREFIX'] . '/../save';

$cfg['CheckConfigurationPermissions'] = false;
$cfg['ShowPhpInfo'] = true;
$cfg['MemoryLimit'] = '-1';