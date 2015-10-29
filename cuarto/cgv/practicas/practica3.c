/*
 * Capitulo 2
 * 'Hello World' de OpenGL
 * Aberto Jaspe Villanueva
 */

#include <GL/glut.h>
GLfloat anguloMuslox = 0.0f;
GLfloat anguloMusloy = 0.0f;
GLfloat anguloMusloz = 0.0f;
GLfloat anguloPiernax = 0.0f;
GLfloat anguloPiernay = 0.0f;
GLfloat anguloPiernaz = 0.0f;
GLint ancho = 500;
GLint alto = 500;
void reshape(int width, int height)
{
    glViewport(0, 0, width, height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    // gloOrtho(-1,1,-1,1,0,2)
    glOrtho(-6, 6, -6, 6, -6, 6);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}

void colocarMuslo()
{
    glRotatef(anguloMuslox,1.0f,0.0f,0.0f);
    glRotatef(anguloMusloy,0.0f,1.0f,0.0f);
    glRotatef(anguloMusloz,0.0f,0.0f,1.0f);
}

void colocarPierna()
{
    glRotatef(anguloPiernax,1.0f,0.0f,0.0f);
    glRotatef(anguloPiernay,0.0f,1.0f,0.0f);
    glRotatef(anguloPiernaz,0.0f,0.0f,1.0f);
}

void display()
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    glColor3f(1.0f,1.0f,1.0f);
    glLoadIdentity();
	glutSolidSphere(0.5,40,40);
    glColor3f(1,0,0);
    colocarMuslo();
    glTranslatef(0,-1.0f,0.0f);
	glutSolidCube(1);
    //Segunda esfera (rodilla)
    glTranslatef(0,-1.0f,0.0f);
    glColor3f(1.0f,1.0f,1.0f);
    glutSolidSphere(0.5,40,40);
    //segundo cubo (pierna)
    colocarPierna();
    glTranslatef(0.0f,-1.0f,0.0f);
    glColor3f(1,0,0);
    glutSolidCube(1);
    glFlush();
    glutSwapBuffers();
    //si esta linea esta comentada solo se muestra una ventana transparente ya que no se vuelca el buffer de escritura en el de visualización
}


void keyboard(unsigned char key, int x, int y)
{
    switch(key)
    {
    case 'q':
    case 'Q':
    //aumentar grados x
    anguloMuslox++;
    break;
    case 'a':
    case 'A':
    //disminuir grados x
    anguloMuslox--;
    break;
    case 'w':
    case 'W':
    //aumentar grados y
    anguloMusloy++;
    break;
    case 's':
    case 'S':
    //disminuir grados y
    anguloMusloy--;
    break;
    case 'e':
    case 'E':
    //aumentar grados z
    anguloMusloz++;
    break;
    case 'd':
    case 'D':
    //disminuir grados z
    anguloMusloz--;
    break;
    case 'r':
    case 'R':
    anguloPiernax++;
    break;
    case 'f':
    case 'F':
    anguloPiernax--;
    break;
    case 't':
    case 'T':
    anguloPiernay++;
    break;
    case 'g':
    case 'G':
    anguloPiernay--;
    break;
    case 'y':
    case 'Y':
    anguloPiernaz++;
    break;
    case 'h':
    case 'H':
    anguloPiernaz--;
    break;
    case 27:
        exit(0);
        break;
    }
}

void idle()
{
    display();
}
void init()
{
    glClearColor(0,0,0,0);
    glEnable(GL_DEPTH_TEST);
}

int main(int argc, char **argv)
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH );
    glutInitWindowPosition(50, 50);
    glutInitWindowSize(ancho, alto);
    glutCreateWindow("Hello OpenGL");
    init();
    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutIdleFunc(idle);
    glutKeyboardFunc(keyboard);
    glutMainLoop();
    return 0;
}
