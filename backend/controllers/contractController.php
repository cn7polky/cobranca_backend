<?php
header("Access-Control-Allow-Origin: *");
include_once '../config/routes.php';
include_once Routes::$db;
include_once Routes::$parcelControll;
include_once Routes::$companyControll;
include_once Routes::$planControll;

class Contract
{
    public static function openContract($clientId, $plan, $installments, $user)
    {
        $pdo = Conexao::getInstance();
        $stmt = $pdo->prepare("INSERT INTO cad_contracts (cad_clients_client_id, cad_plans_plan_id, cad_users_user_id) VALUES (:client, :plan, :user)");
        $stmt->execute(array(
            ':client' => $clientId,
            ':plan' => $plan,
            ':user' => $user
        ));

        if ($stmt->rowCount() > 0) {
            $id_contract = Contract::getContractId($clientId); // id do cliente
            foreach ($installments as $key => $value) {
                if (Parcel::addParcel($value[0], $value[2], $value[1], $id_contract, $clientId) == 'Sucesso') {
                    $msg = array('msg' => 'Contrato aberto com Sucesso');
                } else {
                    $msg = array('msg' => 'Falha ao abrir contrato ou gerar parcelas');
                }
            }
        } else {
            $msg = array('msg' => 'Falha ao abrir contrato');
        }
        echo json_encode($msg);
    }

    public static function getContractId($clientId) // id do cliente
    {
        $pdo = Conexao::getInstance();
        $query = "SELECT contract_id FROM cad_contracts WHERE cad_clients_client_id = '$clientId'";
        $execute = $pdo->query($query);
        foreach ($execute as $key => $value) {
            return $value['contract_id'];
        }
    }

    public static function getContractInfo($id = '', $date = '', $installments = '', $client = '', $return = false)
    {
        $pdo = Conexao::getInstance();
        if ($id != '' && $date == '') {
            $query = "SELECT * FROM cad_contracts WHERE contract_id = '$id'";
        } else {
            $date = explode('-', $date);
            $year = $date[0];
            $month = $date[1];
            $query = "SELECT * FROM cad_contracts WHERE year(contract_dateopen) = '$year' and month(contract_dateopen) = '$month'";
        }
        $execute = $pdo->query($query);
        $info = [];
        foreach ($execute as $key => $value) {
            $dateOpen = explode(' ', $value['contract_dateopen']);
            if ($client == 'true') {
                array_push($info, array(
                    'client' => Client::listClientName($value['cad_clients_client_id'], 'true'),
                ));
            } else if ($installments == '') {
                array_push($info, array(
                    'id' => $value['contract_id'],
                    'status' => $value['contract_status'],
                    'client' => Client::listClientName($value['cad_clients_client_id'], 'true'),
                    'dateOpen' => $dateOpen[0],
                    'plan' => Plan::listPlan($value['cad_plans_plan_id'], 'true'),
                    'installments' => json_decode(Parcel::getParcelId('', $value['contract_id']))
                ));
            } else {
                array_push($info, array(
                    'id' => $value['contract_id'],
                    'status' => $value['contract_status'],
                    'dateOpen' => $dateOpen[0],
                    'client' => Client::listClientName($value['cad_clients_client_id'], 'true'),
                    'plan' => Plan::listPlan($value['cad_plans_plan_id'], 'true'),
                ));
            }
        }
        if ($return == true) {
            return ($info);
        } else {
            echo json_encode($info);
        }
    }

    public static function alterContract($id, $newStatus)
    {
        $pdo = Conexao::getInstance();
        $query = "SELECT * FROM cad_contracts WHERE contract_id = '$id'";
        $execute = $pdo->query($query);
        $status = 'Contrato inexistente';
        foreach ($execute as $key => $value) {
            $status = $value['contract_status'];
        }
        if ($status == 'ABERTO') {
            $query = "UPDATE cad_contracts SET contract_status = :status, contract_dateclose = NOW() WHERE contract_id = :id";
            $stmt = $pdo->prepare($query);
            $stmt->execute(array(
                ':id' => $id,
                ':status' => $newStatus
            ));
            if ($stmt->rowCount() > 0) {
                $msg = array(
                    'msg' => 'Contrato alterado com sucesso',
                    'status' => $newStatus,
                );
            } else {
                $msg = array(
                    'msg' => 'Falha ao alterar contrato',
                    'query' => $query,
                    'status' => $newStatus,
                    'id' => $id,
                );
            }
        } else {
            $msg = array('msg' => $status,);
        }
        echo json_encode($msg);
    }
}

if (isset($_POST['confirm'])) {
    $installments = json_decode($_POST['parcelas']);
    Contract::openContract($_POST['client-id'], $_POST['plan-id'], $installments, $_POST['user-id']);
} else if (isset($_POST['get-contracts'])) {
    Contract::getContractInfo('', $_POST['date'], 'não');
} else if (isset($_POST['get-contract'])) {
    Contract::getContractInfo($_POST['contract-id']);
} else if (isset($_POST['alter-contract'])) {
    Contract::alterContract($_POST['contract-id'], $_POST['contract-status']);
}
