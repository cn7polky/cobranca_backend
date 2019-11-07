<?php
header("Access-Control-Allow-Origin: *");
include_once '../config/routes.php';
include_once Routes::$db;
include_once Routes::$ownerControll;

class Company
{

    public static function register($name, $tel, $adress, $owner)
    {
        $pdo = Conexao::getInstance();
        $stmt = $pdo->prepare("SELECT company_tel FROM cad_companies WHERE company_tel = :tel");
        $stmt->execute(array(':tel' => $tel));
        if ($stmt->rowCount() > 0) {
            $msg = array('msg' => "Empresa ja esta cadastrada");
        } else {
            $stmt = $pdo->prepare("INSERT INTO cad_companies (company_name, company_tel, company_adress, cad_owners_owner_id) VALUES (:name, :tel, :adress, :owner)");
            $adress2 = [];
            array_push($adress2, json_decode($adress));
            $stmt->execute(array(
                ':name' => $name,
                ':tel' => $tel,
                ':adress' => json_encode($adress2),
                ':owner' => $owner
            ));
            if ($stmt->rowCount() > 0) {
                $query = "SELECT company_id FROM cad_companies WHERE company_tel = '$tel'";
                $execute = $pdo->query($query);
                foreach ($execute as $key => $value) {
                    $msg = array(
                        'msg' => "Empresa Cadastrada com sucesso",
                        'company_id' => $value['company_id'],
                        'endereço' => json_encode($adress)
                    );
                }
            } else {
                $msg = array('msg' => "Falha ao Cadastrar Empresa");
            }
        }
        echo json_encode($msg);
    }

    public static function listCompany($id = 'null')
    {
        $pdo = Conexao::getInstance();
        if ($id == 'null') {
            $query = "SELECT * FROM cad_companies WHERE company_active = 'Y'";
        } else {
            $query = "SELECT * FROM cad_companies WHERE company_active = 'Y' AND company_id = '$id'";
        }
        $execute = $pdo->query($query);
        $dados = [];
        foreach ($execute as $key => $value) {
            array_push($dados, array(
                "id" => $value['company_id'],
                "name" => $value['company_name'],
                "tel" => $value['company_tel'],
                "adress" => json_decode($value['company_adress'])[0],
                "owner" => Owner::getOwnerId($value['cad_owners_owner_id']),
                "active" => $value['company_active']
            ));
        }
        echo json_encode($dados);
    }

    public static function listCompanyName($id = 'null', $return = 'null')
    {
        $pdo = Conexao::getInstance();
        if ($id == 'null') {
            $query = "SELECT * FROM cad_companies WHERE company_active = 'Y'";
        } else {
            $query = "SELECT * FROM cad_companies WHERE company_active = 'Y' AND company_id = '$id'";
        }
        $execute = $pdo->query($query);
        $dados = [];
        foreach ($execute as $key => $value) {
            array_push($dados, array(
                "name" => $value['company_name'],
                "owner_id" => Owner::getOwnerId($value['cad_owners_owner_id'])
            ));
        }
        if ($return == 'null') {
            echo json_encode($dados);
        } else {
            return ($dados[0]);
        }
    }

    public static function alterCompany($id, $name, $tel, $adress, $active)
    {
        $pdo = Conexao::getInstance();
        $query = "SELECT * FROM cad_companies WHERE company_id = '$id'";
        $stmt = $pdo->prepare($query);
        $stmt->execute();
        if ($stmt->rowCount() > 0) {
            $query = "UPDATE cad_companies SET company_name = :name, company_tel = :tel, company_adress = :adress, company_active = :active WHERE company_id = :id";
            $stmt = $pdo->prepare($query);
            $stmt->execute(array(
                ":id" => $id,
                ":name" => $name,
                ":tel" => $tel,
                ":adress" => $adress,
                ":active" => $active
            ));
            if ($stmt->rowCount() > 0) {
                $msg = array("msg" => "Dados alterados com sucesso");
            } else {
                $msg = array(
                    "msg" => "Falha ao alterar dados da empresa",
                    "query" => $query,
                );
            }
        } else {
            $msg = array(
                "msg" => "Empresa não encontrada",
                "id" => $id
            );
        }
        echo json_encode($msg);
    }
}

if (isset($_POST['register-company'])) {
    $adress = json_encode(array(
        "street" => $_POST['street'],
        "district" => $_POST['district'],
        "number" => $_POST['number'],
        "cep" => $_POST['cep']
    ));
    Company::register($_POST['name'], $_POST['tel'], $adress, $_POST['owner-id']);
} else if (isset($_POST['companies'])) {
    Company::listCompanyName();
} else if (isset($_POST['all-companies'])) {
    Company::listCompany();
} else if (isset($_POST['this-company'])) {
    Company::listCompany($_POST['company-id']);
}
