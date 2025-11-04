<?php

 if (!($_SERVER['FRANKENPHP_WORKER'] ?? false)) {
    phpinfo();
    exit(0);
 }

ignore_user_abort(true);

$maxRequests = (int)($_SERVER['MAX_REQUESTS'] ?? 0);

for ($nbRequests = 0; !$maxRequests || $nbRequests < $maxRequests; ++$nbRequests) {
    $keepRunning = \frankenphp_handle_request(phpinfo(...));

    gc_collect_cycles();

    if (!$keepRunning) {
        break;
    }
}
