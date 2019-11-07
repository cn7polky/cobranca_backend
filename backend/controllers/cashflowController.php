<?php
header("Access-Control-Allow-Origin: *");
include_once "../config/routes.php";
include_once Routes::$db;
include_once Routes::$userControll;

class CashFlow
{
    public static function add($value, $reason, $type, $userId, $boxId)
    {
        $pdo = Conexao::getInstance();
        $stmt = $pdo->prepare("INSERT INTO cad_cashflow (cashf_value, cashf_reason, cashf_type, cad_users_user_id, cad_box_box_id) VALUES (:value, :reason, :type, :userId, :boxId)");
        $stmt->execute(array(
            ':value' => $value,
            ':reason' => $reason,
            ':type' => $type,
            ':userId' => $userId,
            ':boxId' => $boxId,
        ));
        $str = "Movimentação registrada no caixa: $boxId";
        if ($stmt->rowCount() > 0) {
            $msg = array(
                'msg' => $str,
                'value' => $value,
                'reason' => $reason,
                'type' => $type,
                'userInfo' => User::listUser($userId)
            );
        } else {
            $msg = array('msg' => 'Falha ao Realizar Movimentação Financeira');
        }
        echo json_encode($msg);
    }

    public static function getReceiveds($boxId) {
        $pdo = Conexao::getInstance();
        $data = date('Y') . "-" . date('m') . "-" . date('d');
        $query = "SELECT * FROM cad_recinstallments WHERE cad_box_box_id = '$boxId'";
        $execute = $pdo->query($query);
        $dados = [];
        foreach ($execute as $key => $value) {
            array_push($dados, array(
                "recinId" => $value['recin_id'],
                "recinValue" => $value['recin_value'],
                "recinDate" => $value['recin_date'],
                "installmentId" => $value['cad_installments_installment_id'],
                "boxId" => $value['cad_box_box_id'],
                "userId" => $value['cad_users_user_id'],
            ));
        }
        return json_encode($dados);
    }

    public static function getInputs($boxId) {
        $pdo = Conexao::getInstance();
        $query = "SELECT * FROM cad_cashflow WHERE cad_box_box_id = '$boxId'";
        $execute = $pdo->query($query);
        $dados = [];
        foreach ($execute as $key => $value) {
            array_push($dados, array(
                "cashfId" => $value['cashf_id'],
                "cashfValue" => $value['cashf_value'],
                "cashfDate" => $value['cashf_date'],
                "cashfReason" => $value['cashf_reason'],
                "cashfType" => $value['cashf_type'],
                "userId" => $value['cad_users_user_id'],
                "boxId" => $value['cad_box_box_id']
            ));
        }
        return json_encode($dados);
    }
}

if (isset($_POST['add-cashflow'])) {
    CashFlow::add($_POST['value'], $_POST['reason'], $_POST['type'], $_POST['user-id'], $_POST['box-id']);
}
