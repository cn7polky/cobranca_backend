<?php
date_default_timezone_set('America/Cuiaba');
$dateNow = date('Y-m-d') . " 05:00:00";
$dayAfter = date('Y-m-d', strtotime('+1 Day'));
$dateAfter2 = "$dayAfter 05:00:00";

echo "$dateNow: Hoje";
echo "<br> $dateAfter2: Amanhã";
