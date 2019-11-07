<?php
header("Access-Control-Allow-Origin: *");
include_once "../config/routes.php";
include_once Routes::$db;
include_once Routes::$boxControll;

date_default_timezone_set('America/Cuiaba');

class User
{

    public static function register($name, $email, $tel, $pass)
    {
        $pdo = Conexao::getInstance();
        $stmt = $pdo->prepare("SELECT user_email FROM cad_users WHERE user_email = :email");
        $stmt->execute(array(':email' => $email));
        if ($stmt->rowCount() > 0) {
            $msg = array('msg' => 'Usuario ja esta cadastrado');
        } else {
            $stmt = $pdo->prepare("INSERT INTO cad_users (user_name, user_email, user_tel, user_pass) VALUES (:name, :email, :tel, :pass)");
            $stmt->execute(array(
                ':name' => $name,
                ':email' => $email,
                ':tel' => $tel,
                ':pass' => $pass,
            ));

            if ($stmt->rowCount() > 0) {
                $msg = array('msg' => 'Usuario Cadastrado com Sucesso');
            } else {
                $msg = array('msg' => 'Falha ao Cadastrar Usuario');
            }
        }
        echo json_encode($msg);
    }

    public static function login($email, $pass)
    {
        $pdo = Conexao::getInstance();
        $query = "SELECT * FROM cad_users WHERE user_email = '$email' AND user_pass = '$pass' AND user_status = 'Ativo'";
        $execute = $pdo->query($query);
        $msg = array(
            "msg" => "Falha ao realizar login. Verifique os dados.",
        );
        foreach ($execute as $key => $value) {
            $msg = array(
                "userId" => $value['user_id'],
                "name" => $value['user_name'],
                "email" => $value['user_email'],
                "status" => $value['user_status'],
                "box_status" => Box::verifyBoxStatus($value['user_id']),
                "level" => $value['user_level'],
            );
        }
        echo json_encode($msg);
    }

    public static function listUser($id = 'null', $echo = 'false')
    {
        if ($id != 'null') {
            $query = "SELECT * FROM cad_users WHERE user_id = '$id'";
            $return = true;
        } else {
            $query = "SELECT * FROM cad_users";
            $return = false;
        }
        $pdo = Conexao::getInstance();
        $execute = $pdo->query($query);
        $dados = [];
        foreach ($execute as $key => $value) {
            array_push($dados, array(
                'id' => $value['user_id'],
                'name' => $value['user_name'],
                'email' => $value['user_email'],
                'pass' => $value['user_pass'],
                'tel' => $value['user_tel'],
                'level' => $value['user_level'],
                'status' => $value['user_status']
            ));
        }
        if ($echo == 'true') {
            echo json_encode($dados[0]);
        } else if ($return == true) {
            return json_encode($dados);
        } else {
            echo json_encode($dados);
        }
    }

    public static function alterUser($id, $name, $email, $tel, $pass, $status, $level)
    {
        $pdo = Conexao::getInstance();
        $query = "UPDATE cad_users SET user_name = :name, user_email = :email, user_tel = :tel, user_pass = :pass, user_status = :status, user_level = :level WHERE user_id = :id";
        $stmt = $pdo->prepare($query);
        $stmt->execute(array(
            ':id' => $id,
            ':name' => $name,
            ':email' => $email,
            ':tel' => $tel,
            ':pass'   => $pass,
            ':status'   => $status,
            ':level'   => $level
        ));
        if ($stmt->rowCount() > 0) {
            $msg = array(
                "msg" => "Dados alterados com sucesso"
            );
        } else {
            $msg = array(
                "msg" => "Falha ao alterar dados",
                "stmt" => $stmt
            );
        }
        echo json_encode($msg);
    }
}
//fim da classe

if (isset($_POST['register'])) {
    User::register($_POST['name'], $_POST['email'], $_POST['tel'], $_POST['pass']);
} else if (isset($_POST['login'])) {
    User::login($_POST['email'], $_POST['pass']);
} else if (isset($_POST['alter-user'])) {
    User::alterUser($_POST['user-id'], $_POST['user-name'], $_POST['user-email'], $_POST['user-tel'], $_POST['user-pass'], $_POST['user-status'], $_POST['user-level']);
} else if (isset($_POST['get-users'])) {
    User::listUser();
} else if (isset($_POST['get-user'])) {
    User::listUser($_POST['user-id'], $_POST['echo']);
}
