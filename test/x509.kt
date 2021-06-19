package com.yuxiaor

import java.io.File
import java.io.FileInputStream
import java.security.cert.CertificateFactory
import java.security.cert.X509Certificate
import java.security.interfaces.RSAPublicKey


fun main(args: Array<String>) {
    val inputStream = FileInputStream(File("D:\\demos\\app_pub\\xiaomi_pub_key.cer"))
    val certificateFactory = CertificateFactory.getInstance("X.509")
    val x509Certificate = certificateFactory.generateCertificate(inputStream) as X509Certificate
    val rsaPublicKey = x509Certificate.publicKey as RSAPublicKey
    val module = rsaPublicKey.modulus
    val exponent = rsaPublicKey.publicExponent

    println("module>>> $module")
    println("exponent>>> $exponent")
}