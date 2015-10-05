/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package quadtree;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

/**
 *
 * @author suampa
 */
public class Parser {
    /*
        Declaración de variables
            File -> dirección del archivo.txt
            dim -> entero con la dimensión de la matriz
            nodo -> elemento clase nodo que será el padre
    */
    private File file;
    private FileReader fr;
    private int dim;
    private Nodo nodo;
    private BufferedReader br;
    
    /*
        Constructores
    */
    public Parser(){
        
    }
    
    public Parser(String file) throws FileNotFoundException, IOException{
        this.file = new File(file);
        this.fr = new FileReader(this.file);
        br = new BufferedReader(this.fr);
        this.dim = (int) Math.pow(2, Double.valueOf(br.readLine()));
    }
    
    /*
        Getters y Setters
    */
    
    public void setFile(String file){
        this.file = new File(file);
    }
    
    public File getFile(){
        return this.file;
    }
    
    public int getDim() throws IOException{
        return this.dim;
    }
    
    /*
        Funciones propias de la clase
    */
    
    public Nodo parseFile(int dimension) throws IOException{
        //Funcion que recorre el array y obtiene las dimensiones y el array 
        //con datos
        //linea 1 -> dim; resto datos nodo padre
        char datos[][] = new char[dimension][dimension];
        int x = 0;
        String linea;
        linea = br.readLine();
        while(linea != null){
            datos[x] = linea.toCharArray();
            x++;
            linea = br.readLine();
        }
        
        this.nodo = new Nodo(datos, dimension);
        return this.nodo;
    }
}
