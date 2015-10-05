/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package quadtree;

import java.util.ArrayList;

/**
 *
 * @author suampa
 */
public class Nodo {
    /*
        Declaración de variables
    */
    Boolean hoja;
    private char datos[][];
    private ArrayList<Nodo> hijos;
    
    /*
        Constructores
    */
    public Nodo(){
        this.hoja = true;
        this.hijos = new ArrayList<>();
    }
    
    public Nodo(char datos[][], int dimension){
        this.datos = new char[dimension][dimension];
        this.datos = datos;
        this.hoja = true;
        this.hijos = new ArrayList<>();
    }
    
    /*
        Getters y Setters
    */
    
    public void setDatos(char datos[][]){
        this.datos = datos;
    }
    
    public void setHoja(){
        char control = this.datos[0][0];
        for (int i = 0; i < datos.length; i++) {
            for (int j = 0; j < datos.length; j++) {
                char e = datos[i][j];
                if(e != control){
                    this.hoja = false;
                    return;
                } 
            }
        }
    }
    
    public char[][] getDatos(){
        return this.datos;
    }
    
    public Boolean getHoja(){
        return this.hoja;
    }
    
    /*
        Funciones propias de clase
    */
    public ArrayList<Nodo> analizar(int dimension){
        /*se recorren los datos en dos mitades segun la dimension
        esas mitades en dos mitades, y cada una ira a un cuadrante o hijo
        */
        String linea;
        int sep = dimension/2;
        Nodo n1, n2, n3, n4;
        char datosHijoCuadranteUno[][] = new char[sep][sep];
        char datosHijoCuadranteDos[][] = new char[sep][sep];
        char datosHijoCuadranteTres[][] = new char[sep][sep];
        char datosHijoCuadranteCuatro[][] = new char[sep][sep];;
            for (int i = 0; i < dimension; i++) {
                for (int j = 0; j < dimension; j++) {
                    if((j < sep) && (i< sep))
                        datosHijoCuadranteUno[i][j] = this.datos[i][j];
                    else if((j>= sep) && (i<sep))
                        datosHijoCuadranteDos[i][j%sep] = this.datos[i][j];
                    else if((j<sep) && (i>=sep))
                        datosHijoCuadranteTres[i%sep][j] = this.datos[i][j];
                    else if((j>=sep) && (i>=sep))
                        datosHijoCuadranteCuatro[i%sep][j%sep] = this.datos[i][j];
                }
            }
            n1 = new Nodo(datosHijoCuadranteUno, sep);
            n1.setHoja();
            this.hijos.add(n1);
            n2 = new Nodo(datosHijoCuadranteDos, sep);
            n2.setHoja();
            this.hijos.add(n2);
            n3 = new Nodo(datosHijoCuadranteTres, sep);
            n3.setHoja();
            this.hijos.add(n3);
            n4 = new Nodo(datosHijoCuadranteCuatro, sep);
            n4.setHoja();
            this.hijos.add(n4);
            return this.hijos;
    }
    
    public String imprimir(){
        String res = "(";
        if(this.hoja)
            res += this.datos[0][0];
        else{
            res += "node";
            for (Nodo n : this.hijos) {
                res += n.imprimir();
            }
        }
        
        res+=")";
        return res;
    }
}
