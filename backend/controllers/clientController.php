<?php
header("Access-Control-Allow-Origin: *");
include_once '../config/routes.php';
include_once Routes::$db;

class Client
{
    public static function register($name, $doc, $tel, $adress, $type)
    {
        $pdo = Conexao::getInstance();
        $stmt = $pdo->prepare("SELECT client_tel FROM cad_clients WHERE client_tel = :tel");
        $stmt->execute(array(':tel' => $tel));
        if ($stmt->rowCount() > 0) {
            $msg = array('msg' => "Cliente ja esta cadastrado");
        } else {
            $stmt = $pdo->prepare("INSERT INTO cad_clients (client_name, client_doc, client_tel, client_adress, client_type) VALUES (:name, :doc, :tel, :adress, :type)");
            $adress2 = [];
            array_push($adress2, json_decode($adress));
            $stmt->execute(array(
                ':name' => $name,
                ':doc' => $doc,
                ':tel' => $tel,
                ':adress' => json_encode($adress2),
                ':type' => $type
            ));
            if ($stmt->rowCount() > 0) {
                $query = "SELECT client_id FROM cad_clients WHERE client_tel = '$tel'";
                $execute = $pdo->query($query);
                foreach ($execute as $key => $value) {
                    $msg = array(
                        'msg' => "Cliente Cadastrado com sucesso",
                        'client_id' => $value['client_id'],
                        'endereço' => json_encode($adress)
                    );
                }
            } else {
                $msg = array('msg' => "Falha ao Cadastrar Cliente");
            }
        }
        echo json_encode($msg);
    }

    public static function listClient($id = 'null')
    {
        $pdo = Conexao::getInstance();
        if ($id == 'null') {
            $query = "SELECT * FROM cad_clients WHERE client_status = 'Ativo'";
        } else {
            $query = "SELECT * FROM cad_clients WHERE client_status = 'Ativo' AND client_id = '$id'";
        }
        $execute = $pdo->query($query);
        $dados = [];
        foreach ($execute as $key => $value) {
            array_push($dados, array(
                "id" => $value['client_id'],
                "name" => $value['client_name'],
                "doc" => $value['client_doc'],
                "tel" => $value['client_tel'],
                "adress" => json_decode($value['client_adress'])[0],
                "status" => $value['client_status'],
                "type" => $value['client_type']
            ));
        }
        echo json_encode($dados);
    }

    public static function listClientName($id = 'null', $return = 'null')
    {
        $pdo = Conexao::getInstance();
        if ($id == 'null') {
            $query = "SELECT * FROM cad_clients WHERE client_status = 'Ativo'";
        } else {
            $query = "SELECT * FROM cad_clients WHERE client_status = 'Ativo' AND client_id = '$id'";
        }
        $execute = $pdo->query($query);
        $dados = [];
        foreach ($execute as $key => $value) {
            array_push($dados, array(
                "id" => $value['client_id'],
                "name" => $value['client_name']
            ));
        }
        if ($return == 'null') {
            echo json_encode($dados);
        } else {
            return ($dados[0]);
        }
    }

    public static function alterClient($id, $name, $doc, $tel, $adress, $type, $status)
    {
        $pdo = Conexao::getInstance();
        $query = "SELECT * FROM cad_clients WHERE client_id = '$id'";
        $stmt = $pdo->prepare($query);
        $stmt->execute();
        if ($stmt->rowCount() > 0) {
            $query = "UPDATE cad_clients SET client_name = :name, client_doc = :doc, client_tel = :tel, client_adress = :adress, client_status = :status, client_type = :type WHERE client_id = :id";
            $stmt = $pdo->prepare($query);
            $stmt->execute(array(
                ":id" => $id,
                ":name" => $name,
                ":doc" => $doc,
                ":tel" => $tel,
                ":adress" => $adress,
                ":status" => $status,
                ":type" => $type
            ));
            if ($stmt->rowCount() > 0) {
                $msg = array("msg" => "Dados alterados com sucesso");
            } else {
                $msg = array(
                    "msg" => "Falha ao alterar dados do cliente",
                    "query" => $query,
                );
            }
        } else {
            $msg = array(
                "msg" => "Cliente não encontrado",
                "id" => $id
            );
        }
        echo json_encode($msg);
    }
}

if (isset($_POST['register-client'])) {
    $adress = json_encode(array(
        "street" => $_POST['street'],
        "district" => $_POST['district'],
        "number" => $_POST['number'],
        "cep" => $_POST['cep']
    ));
    Client::register($_POST['name'], $_POST['doc'], $_POST['tel'], $adress, $_POST['type']);
} else if (isset($_POST['clients'])) {
    Client::listClientName();
} else if (isset($_POST['all-clients'])) {
    Client::listClient();
} else if (isset($_POST['this-client'])) {
    Client::listClient($_POST['client-id']);
}
