<?php

function checkLength($string, $minLength = 3, $maxLength = 40)
{
    $length = strlen($string);
    return $length > $minLength && $length < $maxLength;
}

function removeWhitespaces($string)
{
    return trim($string);
}

function validatePhone($phone)
{
    $regex = '/^\01\d{9}$/';
    return preg_match($regex, $phone);
}

function validateEmail($email)
{
    $pattern = '/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/';
    return preg_match($pattern, $email);
}
