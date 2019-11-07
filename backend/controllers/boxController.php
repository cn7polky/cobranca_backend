<?php
header("Access-Control-Allow-Origin: *");
include_once "../config/routes.php";
include_once Routes::$db;
include_once Routes::$userControll;
include_once Routes::$cashFlowControll;

class Box
{
    public static function open($value, $route, $id)
    {
        $pdo = Conexao::getInstance();
        $stmt = $pdo->prepare("INSERT INTO cad_box (box_openvalue, box_route, cad_users_user_id) VALUES (:value, :route, :id)");
        if (Box::verifyBoxId($id) == '') {
            $stmt->execute(array(
                ':value' => $value,
                ':route' => $route,
                ':id' => $id
            ));
            $msg = array(
                "msg" => "Falha ao abrir caixa",
                "user-id" => $id,
                "value" => $value,
            );
            if ($stmt->rowCount() > 0) {
                $msg = array(
                    "msg" => "Caixa aberto com sucesso",
                    "statusBox" => 'ABERTO',
                    "boxId" => Box::verifyBoxId($id)
                );
            }
        } else {
            $msg = array(
                "msg" => "Caixa já está aberto para este usuário",
                "boxInfo" => Box::boxInfo($id),
            );
        }
        echo json_encode($msg);
    }

    public static function closeBox($valueFinal, $boxId, $userId)
    {
        $pdo = Conexao::getInstance();
        $stmt = $pdo->prepare("UPDATE cad_box set box_closedate = :closedate, box_closevalue = :value, box_status = 'FECHADO' WHERE box_id = :boxid AND cad_users_user_id = :userid AND box_status = 'ABERTO'");
        $date = date('Y-m-d H:i:s');
        $stmt->execute(array(
            ':closedate' => $date,
            ':value' => $valueFinal,
            ':boxid' => $boxId,
            ':userid' => $userId
        ));
        if ($stmt->rowCount() > 0) {
            $msg = array(
                "msg" => "Caixa fechado com sucesso",
                "statusBox" => "FECHADO"
            );
        }
        echo json_encode($msg);
    }

    public static function verifyBoxStatus($userId)
    {
        $pdo = Conexao::getInstance();
        $query = "SELECT * FROM cad_box WHERE cad_users_user_id = '$userId' AND box_status = 'ABERTO'";
        $execute = $pdo->query($query);
        $status = ['', 'FECHADO'];
        foreach ($execute as $key => $value) {
            $status = [$value['box_id'], $value['box_status']];
        }
        return $status;
    }

    public static function verifyBoxId($userId)
    {
        $pdo = Conexao::getInstance();
        $query = "SELECT * FROM cad_box WHERE cad_users_user_id = '$userId' AND box_status = 'ABERTO'";
        $execute = $pdo->query($query);
        $caixaId = '';
        foreach ($execute as $key => $value) {
            $caixaId = $value['box_id'];
        }
        return $caixaId;
    }

    public static function boxInfo($userId = 'null', $dateOpen = '', $boxId = '')
    {
        $pdo = Conexao::getInstance();
        if ($userId != 'null' && $boxId == '') {
            $query = "SELECT * FROM cad_box WHERE cad_users_user_id = '$userId' AND box_status = 'ABERTO'";
            $return = true;
        } else if ($boxId != '' && $userId != 'null') {
            $query = "SELECT * FROM cad_box WHERE cad_users_user_id = '$userId' AND box_status = 'ABERTO' AND box_id = '$boxId'";
            $return = true;
        } else if ($dateOpen != '') {
            $query = "SELECT * FROM cad_box WHERE box_opendate >= '$dateOpen 00:00:00' AND box_opendate <= '$dateOpen 23:59:59'";
            $return = false;
        } else if ($boxId != '' && $userId == 'null') {
            $query = "SELECT * FROM cad_box WHERE box_id = '$boxId'";
            $return = true;
        }
        $execute = $pdo->query($query);
        $dados = [];
        foreach ($execute as $key => $value) {
            array_push($dados, array(
                "boxId" => $value['box_id'],
                "openDate" => $value['box_opendate'],
                "openValue" => $value['box_openvalue'],
                "route" => $value['box_route'],
                "userInfo" => json_decode(User::listUser($value['cad_users_user_id'])),
                "status" => $value['box_status']
            ));
        }
        if ($return == true) {
            return ($dados);
        } else {
            echo json_encode($dados);
        }
    }

    public static function getBoxValues($boxId, $userId)
    {
        $pdo = Conexao::getInstance();
        $query = "SELECT * FROM cad_cashflow WHERE cad_box_box_id = '$boxId'";
        $execute = $pdo->query($query);
        $inputs = 0;
        $outputs = 0;
        //primeiro os valores do cashflow
        foreach ($execute as $key => $value) {
            if ($value['cashf_type'] == 'ENTRADA') {
                $inputs += $value['cashf_value'];
            } else {
                $outputs += $value['cashf_value'];
            }
        }
        //agora os valores recebidos das parcelas
        $query = "SELECT * FROM cad_recinstallments WHERE cad_box_box_id = '$boxId'";
        $execute = $pdo->query($query);
        $receiveds = 0;
        foreach ($execute as $key => $value) {
            $receiveds += $value['recin_value'];
        }
        if ($userId != '') {
            $boxInfo = Box::boxInfo($userId, '', $boxId);
        } else {
            $boxInfo = Box::boxInfo('null', '', $boxId);
        }
        $valueTotal = (($inputs + $receiveds + $boxInfo[0]['openValue']) - $outputs);
        $msg = array(
            "boxInfo" => $boxInfo,
            "inputs" => $inputs,
            "outputs" => $outputs,
            "valueTotal" => $valueTotal,
            "receiveds" => $receiveds,
            "boxId" => $boxId,
            "installments" => json_decode(CashFlow::getReceiveds($boxId)),
            "inputsD" => json_decode(CashFlow::getInputs($boxId))
        );
        echo json_encode($msg);
    }
}


if (isset($_POST['open-box'])) {
    Box::open($_POST['value'], $_POST['route'], $_POST['user-id']);
} else if (isset($_POST['close-box'])) {
    Box::closeBox($_POST['value-final'], $_POST['box-id'], $_POST['user-id']);
} else if (isset($_POST['get-box-day'])) {
    Box::boxInfo('null', $_POST['date']);
} else if (isset($_POST['get-box-values'])) {
    Box::getBoxValues($_POST['box-id'], $_POST['user-id']);
} else if (isset($_POST['box-details'])) {
    Box::getBoxValues($_POST['box-id'], '');
}