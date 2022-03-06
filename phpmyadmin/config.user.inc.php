<?php

/* We now have to tell phpMyAdmin that SSL must be used whenever a connection is made. */
$cfg['ForceSSL'] = true;

/* Uploads setup */
$cfg['UploadDir'] = $_ENV['WEBSERVER_DOC_ROOT'] . '/../upload';
$cfg['SaveDir'] = $_ENV['WEBSERVER_DOC_ROOT'] . '/../save';

$cfg['CheckConfigurationPermissions'] = false;
$cfg['ShowPhpInfo'] = true;
$cfg['MemoryLimit'] = '-1';
