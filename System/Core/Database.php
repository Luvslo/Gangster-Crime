<?php


class Database
{
    private static $_instance = null;
    private $_pdo,
        $_query,
        $_error = false,
        $_results,
        $_count = 0;

    private function __construct()
    {
        try {
            $this->_pdo = new PDO('mysql:host='.Config::get('mysql/host').';dbname='.Config::get('mysql/db'),Config::get('mysql/username'),Config::get('mysql/password'));
            //$this->_pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e) {
            die($e->getMessage());
        }
    }

    public static function getInstance()
    {
        if (!isset(self::$_instance)) {
            self::$_instance = new Database();
        }
        return self::$_instance;
    }

    public function query($sql, $params = array())
    {
        $this->_error = false;
        if ($this->_query = $this->_pdo->prepare($sql)) {
            $x = 1;
            if (count($params)) {
                foreach ($params as $param) {
                    $this->_query->bindValue($x, $param);
                    $x++;
                }
            }
            if ($this->_query->execute()) {
                $this->_results = $this->_query->fetchAll(PDO::FETCH_OBJ);
                $this->_count	= $this->_query->rowCount();
            } else {
                $this->_error = true;
            }
        }
        return $this;
    }

    public function action($action, $table, $fields = array(), $order = null, $sort = null)
    {
        $set = '';
        $valueSet = array();
        $x = 1;
        $fieldCount = count($fields);
        foreach($fields as $where){
            if (count($where) == 3) {
                $operators = array('=','>','<','>=','<=','<>');
                $field		= $where[0];
                $operator	= $where[1];
                $value		= $where[2];;
                if (in_array($operator, $operators)) {
                    if($fieldCount > $x){
                        $set .= "${field} {$operator} ? and ";
                    }
                    if($fieldCount == $x){
                        $set .= "${field} {$operator} ?";
                    }
                    array_push($valueSet, $value);
                }
            }
            $x++;
        }
        if(isset($order) && isset($sort)){
            $sql = "{$action} FROM {$table} WHERE {$set} order by {$order} {$sort}";
        }else{
            $sql = "{$action} FROM {$table} WHERE {$set}";
        }

        if (!$this->query($sql, $valueSet)->error()) {
            return $this;
        }
        return false;
    }

    public function get($table, $where = array(), $order = null, $sort = null)
    {
        return $this->action('SELECT *', $table, $where, $order, $sort);
    }

    public function delete($table, $where)
    {
        return $this->action('DELETE', $table, $where);
    }

    public function insert($table, $fields = array())
    {
        if (count($fields)) {
            $keys 	= array_keys($fields);
            $values = null;
            $x 		= 1;
            foreach ($fields as $field) {
                $values .= '?';
                if ($x<count($fields)) {
                    $values .= ', ';
                }
                $x++;
            }
            $sql = "INSERT INTO {$table} (`".implode('`,`', $keys)."`) VALUES({$values})";
            if (!$this->query($sql, $fields)->error()) {
                return true;
            }
        }
        return false;
    }

    public function update($table, $where, $fields = array())
    {
        $set 	= '';
        $x		= 1;
        foreach ($fields as $name => $value) {
            $set .= "{$name} = ?";
            if ($x<count($fields)) {
                $set .= ', ';
            }
            $x++;
        }
        $sql = "UPDATE {$table} SET {$set} WHERE {$where}";

        if (!$this->query($sql, $fields)->error()) {
            return true;
        }
        return false;
    }

    public function countAll($table, $fields = array(), $where = null)
    {
        $set 	= '';
        $x		= 1;
        foreach ($fields as $name => $value) {
            $set .= "SUM(".$name.") as '".$value."' ,";
            if ($x<count($fields)) {
                $set .= "SUM(".$name.") as '".$value."' ,";
            }
            if ($x==count($fields)) {
                $set .= "SUM(".$name.") as '".$value."'";
            }
            $x++;
        }
        if(isset($where)){
            $sql = "SELECT {$set} FROM {$table} {$where}";
        }else{
            $sql = "SELECT {$set} FROM {$table}";
        }

        if (!$this->query($sql, $fields)->error()) {
            return $this->first();
        }
        return false;
    }

    public function results()
    {
        return $this->_results;
    }

    public function first()
    {
        return $this->_results[0];
    }

    public function error()
    {
        return $this->_error;
    }

    public function count()
    {
        return $this->_count;
    }
}