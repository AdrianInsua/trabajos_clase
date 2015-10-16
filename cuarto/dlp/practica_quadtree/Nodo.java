/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DLP;

import java.util.ArrayList;

/**
 *
 * @author suampa
 */
public class Nodo {
    /*
        Declaración de variables
    */
    private Boolean hoja;
    private char datos[][];
    ArrayList<Nodo> hijos;
    private int dim;
    
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
        this.dim = dimension;
    }
    
    /*
        Getters y Setters
    */
    
    public void setDatos(char datos[][]){
        this.datos = datos;
    }
    
    public void setDim(int dim){
        this.dim = dim;
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
    
    public int getDim(){
        return this.dim;
    }
    
    /*
        Funciones propias de clase
    */
    public ArrayList<Nodo> analizar(){
        /*se recorren los datos en dos mitades segun la dimension
        esas mitades en dos mitades, y cada una ira a un cuadrante o hijo
        */
        String linea;
        int sep = this.dim/2;
        Nodo n1, n2, n3, n4;
        char datosHijoCuadranteUno[][] = new char[sep][sep];
        char datosHijoCuadranteDos[][] = new char[sep][sep];
        char datosHijoCuadranteTres[][] = new char[sep][sep];
        char datosHijoCuadranteCuatro[][] = new char[sep][sep];;
            for (int i = 0; i < this.dim; i++) {
                for (int j = 0; j < this.dim; j++) {
                    char dato = this.datos[i][j];
                    if((j < sep) && (i< sep))
                        datosHijoCuadranteUno[i][j] = dato;
                    else if((j>= sep) && (i<sep))
                        datosHijoCuadranteDos[i][j%sep] = dato;
                    else if((j<sep) && (i>=sep))
                        datosHijoCuadranteTres[i%sep][j] = dato;
                    else if((j>=sep) && (i>=sep))
                        datosHijoCuadranteCuatro[i%sep][j%sep] = dato;
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
            if(!this.hoja) this.datos = null;
            return this.hijos;
    }
    
    /*
        Funcion de imprimir de estilo recursivo
            Se concatena el resultado de la funcion que resulte de los hijos del 
            nodo actual
    */
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
    
    public char[][] decodificar(){
        int sep = this.dim/2;
        char deco[][] = new char[this.dim][this.dim];
        char pc[][] = new char[sep][sep];
        char sc[][] = new char[sep][sep];
        char tc[][] = new char[sep][sep];
        char cc[][] = new char[sep][sep];
        if(this.hoja){
            //si es hoja se compone el cuadrante necesario con el mismo dato
            for (int i = 0; i < this.dim; i++) {
                for (int j = 0; j < this.dim; j++) {
                    deco[i][j] = this.datos[0][0];                    
                }
            }
        }else{
            pc = this.hijos.get(0).decodificar();
            sc = this.hijos.get(1).decodificar();
            tc = this.hijos.get(2).decodificar();
            cc = this.hijos.get(3).decodificar();
            //guardar datos en deco
            for (int i = 0; i < this.dim; i++) {
                for (int j = 0; j < this.dim; j++) {
                    if(i<sep && j<sep)
                        deco[i][j] = pc[i][j];
                    if(i>=sep && j<sep)
                        deco[i][j] = tc[i%sep][j];
                    if(i<sep && j>=sep)
                        deco[i][j] = sc[i][j%sep];
                    if(i>=sep && j>=sep)
                        deco[i][j] = cc[i%sep][j%sep];
                }     
            }
        }
        return deco;
    }
}
