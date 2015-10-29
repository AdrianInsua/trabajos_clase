/*
 * Capitulo 2
 * 'Hello World' de OpenGL
 * Aberto Jaspe Villanueva
 */

#include <GL/glut.h>

void reshape(int width, int height)
{
    glViewport(0, 0, width, height);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    // gloOrtho(-1,1,-1,1,0,2)
    glOrtho(-3, 3, -3, 3, -3, 3);
}

void display()
{
	glClear(GL_COLOR_BUFFER_BIT);
    //glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glColor3f(1,1,1);
    glLoadIdentity();
 //el orden de los angulos sigue sentido horario si avanza en el sentido positivo del eje x y antihorario en caso contrario
 /*
	glColor3f(1.0f, 1.0f, 1.0f);      // activamos el color blanco
	glBegin(GL_TRIANGLES);
		  glVertex3f(-1.0f,      -1.0f, -1.0f);
		  glVertex3f(1.0f,      -1.0f, -1.0f);
		  glVertex3f(0.0f,      1.0f, -1.0f);
	glEnd();
 
	glColor3f(1.0f, 0.0f, 0.0f);      // activamos el color rojo
	glBegin(GL_QUADS);
		  glVertex3f(-1.0f, -1.0f, -2.0f);
		  glVertex3f(-1.0f, 1.0f, -2.0f);
		  glVertex3f(1.0f, 1.0f, -2.0f);
		  glVertex3f(1.0f, -1.0f, -2.0f);
	glEnd(); 
	*/
	//glRotatef(60, 0.0f, 1.0f, 0.0f);
	//glutWireSphere(1.0,40,20);
	//glutSolidSphere(1.0,40,20);
	glutSolidCube(0.3);
	//glutWireCube(2.0);
	//glutSolidTorus(0.3,1.0,50,50);
	//glutWireTorus(0.2,0.5,50,50);
	//glutWireCone(1.0,2.0,50,50);
	glutWireTeapot(0.5f);
    glFlush();
    //si esta linea esta comentada solo se muestra una ventana transparente ya que no se vuelca el buffer de escritura en el de visualización
}

void init()
{
    glClearColor(0,0,0,0);
    //glEnable(GL_DEPTH_TEST);
}

int main(int argc, char **argv)
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB | GLUT_DEPTH );
    glutInitWindowPosition(50, 50);
    glutInitWindowSize(500, 500);
    glutCreateWindow("Hello OpenGL");
    init();
    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutMainLoop();
    return 0;
}
