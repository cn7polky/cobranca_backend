<?php

header("Access-Control-Allow-Origin: *");
include_once "../config/routes.php";
include_once Routes::$db;

class Plan
{
    public static function listAllPlans()
    {
        $pdo = Conexao::getInstance();
        $query = "SELECT * FROM cad_plans";
        $execute = $pdo->query($query);
        $dados = [];
        foreach ($execute as $key => $value) {
            array_push($dados, array(
                "id" => $value['plan_id'],
                "value" => $value['plan_values'],
                "p11" => $value['plan_11'],
                "p24" => $value['plan_24'],
            ));
        }
        echo json_encode($dados);
    }

    public static function listPlan($id, $return = 'null')
    {
        $pdo = Conexao::getInstance();
        $query = "SELECT * FROM cad_plans WHERE plan_id = '$id'";
        $execute = $pdo->query($query);
        $dados = [];
        foreach ($execute as $key => $value) {
            array_push($dados, array(
                "id" => $value['plan_id'],
                "value" => $value['plan_values'],
                "p11" => $value['plan_11'],
                "p24" => $value['plan_24'],
            ));
        }
        if ($return == 'null') {
            echo json_encode($dados);
        } else {
            return ($dados);
        }
    }
}

if (isset($_POST['all-plans'])) {
    Plan::listAllPlans();
} else if (isset($_POST['plan'])) {
    Plan::listPlan($_POST['plan-id']);
}
