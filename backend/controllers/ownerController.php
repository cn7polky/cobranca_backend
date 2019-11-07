<?php

header("Access-Control-Allow-Origin: *");
include_once "../config/routes.php";
include_once Routes::$db;

class Owner
{
    public static function register($name, $cpf, $adress, $tel)
    {
        $pdo = Conexao::getInstance();
        $stmt = $pdo->prepare("INSERT INTO cad_owners (owner_name, owner_cpf, owner_adress, owner_tel) VALUES (:name, :cpf, :adress, :tel)");
        $stmt->execute(array(
            ':name' => $name,
            ':cpf' => $cpf,
            ':adress' => $adress,
            ':tel' => $tel
        ));
        if ($stmt->rowCount() > 0) {
            $query = "SELECT owner_id FROM cad_owners WHERE owner_cpf = '$cpf'";
            $execute = $pdo->query($query);
            foreach ($execute as $key => $value) {
                $msg = array(
                    "msg" => "Cadastro realizado com sucesso",
                    "owner_id" => $value['owner_id']
                );
            }
        }
        echo json_encode($msg);
    }

    public static function getOwnerId($id)
    {
        $pdo = Conexao::getInstance();
        $query = "SELECT * FROM cad_owners WHERE owner_id = '$id'";
        $execute = $pdo->query($query);
        $dados = [];
        foreach ($execute as $key => $value) {
            array_push($dados, array(
                "name" => $value['owner_name'],
                "cpf" => $value['owner_cpf'],
                "adress" => json_decode($value['owner_adress']),
                "tel" => $value['owner_tel']
            ));
        }
        return ($dados[0]);
    }

    public static function alterOwner($id, $name, $cpf, $adress, $tel)
    {
        $pdo = Conexao::getInstance();
        $query = "SELECT * FROM cad_owners WHERE owner_id = '$id'";
        $stmt = $pdo->prepare($query);
        $stmt->execute();
        if ($stmt->rowCount() > 0) {
            $query = "UPDATE cad_owners SET owner_name = :name, owner_cpf = :cpf, owner_adress = :adress, owner_tel = :tel WHERE owner_id = :id";
            $stmt = $pdo->prepare($query);
            $adress2 = [];
            array_push($adress2, json_decode($adress));
            $stmt->execute(array(
                ":id" => $id,
                ":name" => $name,
                ":cpf" => $cpf,
                ":adress" => json_encode($adress2),
                ":tel" => $tel
            ));
            if ($stmt->rowCount() > 0) {
                $msg = array("msg" => "Dados alterados com sucesso");
            } else {
                $msg = array(
                    "msg" => "Falha ao alterar dados do Cliente",
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

if (isset($_POST['register-owner'])) {
    $adress = json_encode(array(
        "street" => 'rua',
        "district" => $_POST['district'],
        "number" => $_POST['number'],
        "cep" => $_POST['cep']
    ));
    Owner::register($_POST['name'], $_POST['cpf'], $adress, $_POST['tel']);
}
