/*
 * Capitulo 2
 * 'Hello World' de OpenGL
 * Aberto Jaspe Villanueva
 */

#include <GL/glut.h>

void reshape(int width, int height)
{
    glViewport(0, 0, 500, 500);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    // gloOrtho(-1,1,-1,1,0,2)
    glOrtho(-1, 1, -1, 1, -1, 1);
    glMatrixMode(GL_MODELVIEW);
}

void display()
{
    glClear(GL_COLOR_BUFFER_BIT);
    glColor3f(1,1,1);
    glLoadIdentity();
    glBegin(GL_TRIANGLES);
    /*
 *      para moverlo hacia atras pondria las coordenadas del eje z a -1, el triangulo no
 *      disminuye de tamaño por que el punto de vista es desde el eje z
 *
 *      si z = 2 o z = -2 el triangulo se escapa de la zona de visión por lo que no se visualiza
 *
 *      si z = -2 en el vertice superior la mitad superior del triangulo desaparece del campo de visión
 *
 */
    glVertex3f(-1,-1,0);
    glVertex3f(1,-1,0);
    glVertex3f(0,1,0);
    glEnd();
    glFlush();
    //si esta linea esta comentada solo se muestra una ventana transparente ya que no se vuelca el buffer de escritura en el de visualización
    glutSwapBuffers();
}

void init()
{
    glClearColor(0,0,0,0);
}

int main(int argc, char **argv)
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
    glutInitWindowPosition(50, 50);
    glutInitWindowSize(500, 500);
    glutCreateWindow("Hello OpenGL");
    init();
    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutMainLoop();
    return 0;
}
