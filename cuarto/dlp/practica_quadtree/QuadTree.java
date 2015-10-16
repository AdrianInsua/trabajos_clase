/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DLP;

//prueba1

import java.io.IOException;
import java.util.ArrayList;

/**
 *
 * @author suampa
 */
public class QuadTree {

    /**
     * @param args the command line arguments
     *  -f = direccion del archivo con la matriz de datos
        *  -p = imprime por pantalla la imagen
        *  -c = codificacion
        *  -pa = imprime el arbol codificado
        *  -d = decodifica el arbol obtenido
        *  -pd = imprime el arbol decodificado
     */
    public static void main(String[] args) throws IOException {
        //Declaración de variables
        String file = null, arg, codificacion = null;
        int dimension;
        Boolean p = false, c = false, pa = false, d = false, pd = false;
        Parser parser;
        Nodo quadTree;
        //array para guardor los hijos del nivel a analizar
        ArrayList<Nodo> hijos = null; 
        //array auxiliar para guardar los hijos del nodo analizado
        ArrayList<Nodo> nuevosHijos = new ArrayList<Nodo>(); 
        //array auxiliar para decodificacion
        char deco[][] = null;
        
        //Analisis de las opciones de ejecución
        for (int i = 0; i < args.length; i++) {
            arg = args[i];
            if(arg.compareTo("-f") == 0){
                file = args[i+1];
                i++;
            }else{
                switch(arg.toLowerCase()){
                    case "-p":
                        p = true;
                        break;
                    case "-c":
                        c= true;
                        break;
                    case "-pa":
                        pa = true;
                        break;
                    case "-d":
                        d = true;
                        break;
                    case "-pd":
                        pd = true;
                        break;
                    default:
                        System.err.println("Comando desconocido");
                        System.exit(0);                        
                }
            }
        }
        
        if(file.isEmpty()){
            System.err.println("Es necesario introducir la ruta del fichero");
            System.exit(0);
        }
        
        /*
            Construcción del primer nodo desde el parser
        */
        parser = new Parser(file);
        dimension = parser.getDim();
        
        quadTree = parser.parseFile(dimension);
        quadTree.setHoja();
        
        if(p){ //impresion de la matriz
            char datos[][] = quadTree.getDatos();
            System.out.println("Matriz de datos");
            for (int i = 0; i < datos.length; i++) {
                for (int j = 0; j < datos.length; j++) {
                    System.out.print(datos[i][j]);
                }
                System.out.println();
            }
        }
            
        /*
            Construccion árbol
            Se entra si el primer nodo no es hoja y está activada la codificacion
        */
        if(!quadTree.getHoja() && c){
            //clonamos los resultados para que no se linkeen en memoria
            hijos = (ArrayList) quadTree.analizar().clone();
            while (hijos.size() > 0) {
                //reiniciamos la variable auxiliar
                nuevosHijos.clear();
                for (Nodo hijo : hijos) {
                    if (hijo != null) {
                        if (!hijo.getHoja()) {
                            //se alladen los resultados de analizar todos los hijos
                            nuevosHijos.addAll((ArrayList)hijo.analizar().clone());
                        }
                    }
                }
                hijos.clear();
                hijos.addAll(nuevosHijos);
            }
        }
        
        //impresion del arbol
        if(pa){
            System.out.println("\nArbol codificado");
            codificacion = quadTree.imprimir();
            System.out.println(codificacion);
        }
        
         /*
        TODO:
            decodificacion
        */
        
        if(d){
            System.out.println("\nDescodificando arbol...");
            deco = quadTree.decodificar();
        }
        
        /*
            Impresion decodificacion
        */
        if(pd){
            System.out.println("\nArbol descodificado");
            if(deco.length > 0){
                for (int i = 0; i < deco.length; i++) {
                    char[] deco1 = deco[i];
                    for (int j = 0; j < deco1.length; j++) {
                        char e = deco1[j];
                        System.out.print(e);
                    }
                    System.out.println("");
                }
            }
        }
    }
    
}
