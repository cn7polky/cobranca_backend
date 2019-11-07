<?php
header("Access-Control-Allow-Origin: *");
include_once '../config/routes.php';
include_once Routes::$db;
include_once Routes::$contractControll;

class Parcel
{
    public static function addParcel($value, $numberP, $date, $contract, $company)
    {
        $pdo = Conexao::getInstance();
        $stmt = $pdo->prepare("INSERT INTO cad_installments (installment_value, installment_remaing, installment_number, installment_date, cad_contracts_contract_id, cad_companies_company_id) VALUES (:value, :remaing, :numberP, STR_TO_DATE(:date, '%d/%m/%Y'), :contract, :company)");
        $stmt->execute(array(
            ':value' => $value,
            ':remaing' => $value,
            ':numberP' => $numberP,
            ':date' => $date,
            ':contract' => $contract,
            ':company' => $company
        ));

        if ($stmt->rowCount() > 0) {
            return 'Sucesso';
        } else {
            return 'Falha';
        }
    }

    public static function getPendents()
    {
        $pdo = Conexao::getInstance();
        $data = date('Y') . "-" . date('m') . "-" . date('d');
        $query = "SELECT * FROM cad_installments WHERE installment_status = 'PENDENTE' AND installment_date = '$data'";
        $execute = $pdo->query($query);
        $dados = [];
        foreach ($execute as $key => $value) {
            array_push($dados, array(
                'id' => $value['installment_id'],
                'value' => $value['installment_value'],
                'number' => $value['installment_number'],
                'date' => $value['installment_date'],
                'historic' => $value['installment_historic'],
                'status' => $value['installment_status'],
                'company' => Company::listCompanyName($value['cad_companies_company_id'], 'true')
            ));
        }
        echo json_encode($dados);
    }

    public static function getReceiveds()
    {
        $pdo = Conexao::getInstance();
        $data = date('Y') . "-" . date('m') . "-" . date('d');
        $query = "SELECT * FROM cad_installments WHERE installment_status = 'RECEBIDA' AND installment_date = '$data'";
        $execute = $pdo->query($query);
        $dados = [];
        foreach ($execute as $key => $value) {
            array_push($dados, array(
                'id' => $value['installment_id'],
                'value' => $value['installment_value'],
                'number' => $value['installment_number'],
                'date' => $value['installment_date'],
                'historic' => $value['installment_historic'],
                'status' => $value['installment_status'],
                'company' => Company::listCompanyName($value['cad_companies_company_id'], 'true')
            ));
        }
        echo json_encode($dados);
    }

    public static function getCharged()
    {
        $pdo = Conexao::getInstance();
        $date = date('Y') . "-" . date('m') . "-" . date('d');
        $query = "SELECT * FROM cad_installments WHERE installment_status = 'COBRADO' AND installment_date = '$date'";
        $execute = $pdo->query($query);
        $dados = [];
        foreach ($execute as $key => $value) {
            array_push($dados, array(
                'id' => $value['installment_id'],
                'value' => $value['installment_value'],
                'number' => $value['installment_number'],
                'date' => $value['installment_date'],
                'historic' => $value['installment_historic'],
                'status' => $value['installment_status'],
                'company' => Company::listCompanyName($value['cad_companies_company_id'], 'true')
            ));
        }
        echo json_encode($dados);
    }

    public static function getParcelId($id = '', $contract = '', $box = '')
    {
        $pdo = Conexao::getInstance();
        $return = false;
        if ($id != '' && $contract == '') {
            $query = "SELECT * FROM cad_installments WHERE installment_id = '$id'";
        } else if ($contract != '') {
            $query = "SELECT * FROM cad_installments WHERE cad_contracts_contract_id = '$contract'";
            $return = true;
        } else if ($box != '') {
            $query = "SELECT * FROM cad_installments WHERE cad_box_box_id = '$box'";
            $return = true;
        }
        $execute = $pdo->query($query);
        $dados = [];
        foreach ($execute as $key => $value) {
            array_push($dados, array(
                'id' => $value['installment_id'],
                'value' => $value['installment_value'],
                'remaing' => $value['installment_remaing'],
                'number' => $value['installment_number'],
                'date' => $value['installment_date'],
                'historic' => $value['installment_historic'],
                'status' => $value['installment_status'],
                'company' => Company::listCompanyName($value['cad_companies_company_id'], 'true')
            ));
        }
        if ($return == false) {
            echo json_encode($dados);
        } else {
            return json_encode($dados);
        }
    }

    public static function pay($id, $userId, $amount, $box, $remaing = '', $details, $status = '')
    {
        $pdo = Conexao::getInstance();
        $date = date('Y') . "-" . date('m') . "-" . date('d');
        $hour = date('H') . ":" . date('i');
        $query = "SELECT * FROM cad_installments WHERE installment_id = '$id'";
        $execute = $pdo->query($query);
        $historic = array(
            "date" => $date,
            "hour" => $hour,
            "amount" => $amount,
            "details" => $details
        );
        $next = false;
        $array = array($historic);
        $contract = '';
        foreach ($execute as $key => $value) {
            $contract = $value['cad_contracts_contract_id'];
            if (strlen($value['installment_historic']) > 0) {
                $historicOld = json_decode($value['installment_historic']);
                foreach ($historicOld as $key2 => $value2) {
                    array_push($array, $value2);
                }
            }
            if ($value['installment_remaing'] >= $amount) {
                $next = true;
            }
        }
        if ($next == true) {
            $query = "UPDATE cad_installments SET cad_box_box_id = :box, installment_status = :status, installment_remaing = :remaing, installment_historic = :historic WHERE installment_id = :id";
            $stmt = $pdo->prepare($query);

            $stmt->execute(array(
                ':box' => $box,
                ':status' => $status,
                ':remaing' => $remaing,
                ':historic' => json_encode($array),
                ':id'   => $id,
            ));
            if ($stmt->rowCount() > 0) {
                if ($amount > 0) {
                    $stmt = $pdo->prepare("INSERT INTO cad_recinstallments (recin_value, cad_installments_installment_id, cad_box_box_id, cad_users_user_id) VALUES (:value, :idParcel, :boxId, :userId)");
                    $stmt->execute(array(
                        ':value' => $amount,
                        ':idParcel' => $id,
                        ':boxId' => $box,
                        ':userId' => $userId,
                    ));
                    if ($stmt->rowCount() > 0) {
                        $query = "SELECT * FROM cad_installments WHERE cad_contracts_contract_id = '$contract' AND installment_status != 'RECEBIDA'";
                        $stmt = $pdo->prepare($query);
                        $stmt->execute();
                        if ($stmt->rowCount() == 0) {
                            Contract::alterContract($contract, 'FECHADO');
                        }
                        $msg = array(
                            "msg" => "Pagamento realizado com sucesso. Valor adicionado ao caixa.",
                            "box" => $box
                        );
                    } else {
                        $msg = array(
                            "msg" => "Falha ao adicionar ao caixa",
                            "box" => $box,
                            "stmt" => $stmt
                        );
                    }
                } else {
                    $msg = array(
                        "msg" => "Nenhuma movimentação financeira para esta operação!",
                        "box" => $box
                    );
                }
            } else {
                $msg = array(
                    "msg" => "Falha ao realizar pagamento",
                    "box" => $box,
                    "stmt" => $stmt
                );
            }
        } else {
            $msg = array(
                "msg" => "Falha ao realizar pagamento. Valor inválidp",
                "box" => $box,
            );
        }
        echo json_encode($msg);
    }
}

if (isset($_POST['pendents-installments'])) {
    Parcel::getPendents();
} else if (isset($_POST['receiveds-installments'])) {
    Parcel::getReceiveds();
} else if (isset($_POST['charged-installments'])) {
    Parcel::getCharged();
} else if (isset($_POST['parcelinfo'])) {
    Parcel::getParcelId($_POST['parcel-id']);
} else if (isset($_POST['pay'])) {
    Parcel::pay($_POST['id'], $_POST['user-id'], $_POST['amount'], $_POST['box-id'], $_POST['remaing'], $_POST['details'], $_POST['status']);
} else if (isset($_POST['not-pay'])) {
    Parcel::pay($_POST['id'], $_POST['user-id'], $_POST['amount'], $_POST['box-id'], $_POST['remaing'], $_POST['details'], $_POST['status']);
}
