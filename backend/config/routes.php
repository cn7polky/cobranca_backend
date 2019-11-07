<?php
header("Access-Control-Allow-Origin: *");

class Routes {
    public static $companyControll = '../controllers/companyController.php';
    public static $contractControll = '../controllers/contractController.php';
    public static $ownerControll = '../controllers/ownerController.php';
    public static $parcelControll = '../controllers/parcelController.php';
    public static $planControll = '../controllers/planController.php';
    public static $userControll = '../controllers/userController.php';
    public static $boxControll = '../controllers/boxController.php';
    public static $cashFlowControll = '../controllers/cashflowController.php';
    public static $userModel = '../models/userModel.php';
    public static $db = '../database/db.php';
}