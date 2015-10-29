/*
 * Capítulo 4
 * 'Cube' de OpenGL
 * Aberto Jaspe Villanueva
 */

#include <GL/glut.h>

int articulacion = 0;
#define NUM_ARTICULACIONES 9
GLfloat anguloX[NUM_ARTICULACIONES]; //angulos del cubo
GLfloat anguloY[NUM_ARTICULACIONES];
GLfloat anguloZ[NUM_ARTICULACIONES];
GLfloat anguloEsfera = 0.0f;

int hazPerspectiva = 0;

void reshape(int width, int height)
{
    glViewport(0, 0, width, height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    
    if(hazPerspectiva)
	gluPerspective(60.0f, (GLfloat)width/(GLfloat)height, 1.0f, 20.0f);
    else
	glOrtho(-10, 10, -10, 10, -10, 10);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

}

void drawCube(float alto, float ancho, float largo) {
    
    glBegin(GL_QUADS);  //cara frontal
		glVertex3f(-ancho, -alto,  largo);
		glVertex3f( ancho, -alto,  largo);
		glVertex3f( ancho,  alto,  largo);
		glVertex3f(-ancho,  alto,  largo);
    glEnd();

    glBegin(GL_QUADS);  //cara trasera
		glVertex3f( ancho, -alto, -largo);
		glVertex3f(-ancho, -alto, -largo);
		glVertex3f(-ancho,  alto, -largo);
		glVertex3f( ancho,  alto, -largo);
    glEnd();

    glBegin(GL_QUADS);  //cara lateral izq
		glVertex3f(-ancho, -alto, -largo);
		glVertex3f(-ancho, -alto,  largo);
		glVertex3f(-ancho,  alto,  largo);
		glVertex3f(-ancho,  alto, -largo);
    glEnd();

    glBegin(GL_QUADS);  //cara lateral dcha
		glVertex3f( ancho, -alto,  largo);
		glVertex3f( ancho, -alto, -largo);
		glVertex3f( ancho,  alto, -largo);
		glVertex3f( ancho,  alto,  largo);
    glEnd();

    glBegin(GL_QUADS);  //cara arriba
		glVertex3f(-ancho,  alto,  largo);
		glVertex3f( ancho,  alto,  largo);
		glVertex3f( ancho,  alto, -largo);
		glVertex3f(-ancho,  alto, -largo);
    glEnd();

    glBegin(GL_QUADS);  //cara abajo
		glVertex3f( ancho, -alto, -largo);
		glVertex3f( ancho, -alto,  largo);
		glVertex3f(-ancho, -alto,  largo);
		glVertex3f(-ancho, -alto, -largo);
    glEnd();
}

void colocarCintura(){
	glRotatef(anguloX[0], 1.0f, 0.0f, 0.0f);
    glRotatef(anguloY[0], 0.0f, 1.0f, 0.0f);
    glRotatef(anguloZ[0], 0.0f, 0.0f, 1.0f);
}

void colocarTorax(){
	colocarCintura();
    glTranslatef(0.0f, 1.5f, 0.0f);
}
/*------------------------------------*/
void colocarHombro(int lado){
	int art;
	
	colocarTorax();
    glTranslatef(2*lado, 1, 0);
    if (lado > 0) {
		art = 1;
	} else {
		art = 2;
	}
	glRotatef(anguloX[art], 1.0f, 0.0f, 0.0f);
    glRotatef(anguloY[art], 0.0f, 1.0f, 0.0f);
    glRotatef(anguloZ[art], 0.0f, 0.0f, 1.0f);
}

void colocarBrazo(int lado){
	colocarHombro(lado);
	glTranslatef(0, -1.5, 0.0f);
}

void colocarCodo(int lado){
	int art;
	
	colocarBrazo(lado);
    glTranslatef(0, -1, 0);
    if (lado > 0) {
		art = 3;
	} else {
		art = 4;
	}
	glRotatef(anguloX[art], 1.0f, 0.0f, 0.0f);
    glRotatef(anguloY[art], 0.0f, 1.0f, 0.0f);
    glRotatef(anguloZ[art], 0.0f, 0.0f, 1.0f);
}

void colocarAntebrazo(int lado){
	colocarCodo(lado);
	glTranslatef(0, -1.5, 0.0f);
}

/*------------------------------*/

void colocarPierna(int lado){
	int art;
	
    glTranslatef(0.5*lado, -0.5, 0);
    if (lado > 0) {
		art = 5;
	} else {
		art = 6;
	}
	glRotatef(anguloX[art], 1.0f, 0.0f, 0.0f);
    glRotatef(anguloY[art], 0.0f, 1.0f, 0.0f);
    glRotatef(anguloZ[art], 0.0f, 0.0f, 1.0f);
}

void colocarMuslo(int lado){
	colocarPierna(lado);
	glTranslatef(0, -1.5, 0.0f);
}

void colocarRodilla(int lado){
	int art;
	
	colocarMuslo(lado);
    glTranslatef(0, -1, 0);
    if (lado > 0) {
		art = 7;
	} else {
		art = 8;
	}
	glRotatef(anguloX[art], 1.0f, 0.0f, 0.0f);
    glRotatef(anguloY[art], 0.0f, 1.0f, 0.0f);
    glRotatef(anguloZ[art], 0.0f, 0.0f, 1.0f);
}

void colocarPantorrilla(int lado){
	colocarRodilla(lado);
	glTranslatef(0, -1.5, 0.0f);
}

/*------------------------------*/

void display()
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	//Cintura esfera
	glLoadIdentity();
	
	colocarCintura();

    glColor3f(1.0f, 1.0f, 1.0f);
    glutSolidSphere(1, 16, 16);

	//Torax cubo
    glLoadIdentity();
    
    colocarTorax();

	glColor3f(1.0f, 0.0f, 0.0f);
    drawCube(1.5f, 1.5f, 1.5f);
    
    //Hombro izquierdo esfera
    glLoadIdentity();
    
    colocarHombro(1);
    
    glColor3f(1.0f, 1.0f, 1.0f);
    glutSolidSphere(0.5f, 16, 16);
    
    //Brazo izquierdo cubo
    glLoadIdentity();
    
    colocarBrazo(1);
	
	glColor3f(0.0f, 1.0f, 0.0f);
	drawCube(1, 0.5f, 0.5f);
	
	//Codo izquierdo esfera
	glLoadIdentity();
    
    colocarCodo(1);
	
	glColor3f(1.0f, 1.0f, 1.0f);
	glutSolidSphere(0.5f, 16, 16);
	
	//Antebrazo izquierdo cubo
    glLoadIdentity();
    
    colocarAntebrazo(1);
	
	glColor3f(0.0f, 1.0f, 0.0f);
	drawCube(1, 0.5f, 0.5f);
	
	//Hombro derecho esfera
    glLoadIdentity();
    
    colocarHombro(-1);
    
    glColor3f(1.0f, 1.0f, 1.0f);
    glutSolidSphere(0.5f, 16, 16);
    
    //Brazo derecho cubo
    glLoadIdentity();
    
    colocarBrazo(-1);
	
	glColor3f(0.0f, 1.0f, 0.0f);
	drawCube(1, 0.5f, 0.5f);
	
	//Codo derecho esfera
	glLoadIdentity();
    
    colocarCodo(-1);
	
	glColor3f(1.0f, 1.0f, 1.0f);
	glutSolidSphere(0.5f, 16, 16);
	
	//Antebrazo derecho cubo
    glLoadIdentity();
    
    colocarAntebrazo(-1);
	
	glColor3f(0.0f, 1.0f, 0.0f);
	drawCube(1, 0.5f, 0.5f);
	
	//Pierna derecha esfera
	glLoadIdentity();
    
    colocarPierna(-1);
    
    glColor3f(1.0f, 1.0f, 1.0f);
    glutSolidSphere(0.5f, 16, 16);
    
    //Muslo derecho cubo
    glLoadIdentity();
    
    colocarMuslo(-1);
	
	glColor3f(0.0f, 1.0f, 0.0f);
	drawCube(1, 0.5f, 0.5f);
	
	//Rodilla derecho esfera
	glLoadIdentity();
    
    colocarRodilla(-1);
	
	glColor3f(1.0f, 1.0f, 1.0f);
	glutSolidSphere(0.5f, 16, 16);
	
	//Pantorrilla derecho cubo
    glLoadIdentity();
    
    colocarPantorrilla(-1);
	
	glColor3f(0.0f, 1.0f, 0.0f);
	drawCube(1, 0.5f, 0.5f);
	
	//Pierna izquierda esfera
	glLoadIdentity();
    
    colocarPierna(1);
    
    glColor3f(1.0f, 1.0f, 1.0f);
    glutSolidSphere(0.5f, 16, 16);
    
    //Muslo izquierda cubo
    glLoadIdentity();
    
    colocarMuslo(1);
	
	glColor3f(0.0f, 1.0f, 0.0f);
	drawCube(1, 0.5f, 0.5f);
	
	//Rodilla izquierda esfera
	glLoadIdentity();
    
    colocarRodilla(1);
	
	glColor3f(1.0f, 1.0f, 1.0f);
	glutSolidSphere(0.5f, 16, 16);
	
	//Pantorrilla izquierda cubo
    glLoadIdentity();
    
    colocarPantorrilla(1);
	
	glColor3f(0.0f, 1.0f, 0.0f);
	drawCube(1, 0.5f, 0.5f);

/*-------------------------------------*/

    glFlush();
    glutSwapBuffers();
	
}

void init()
{
    glClearColor(0,0,0,0);

    glEnable(GL_DEPTH_TEST);
}

void idle()
{
    display();
}

void keyboard(unsigned char key, int x, int y)
{
    switch(key)
    {
    case 'p':
    case 'P':
	hazPerspectiva=1;
	reshape(400,400);
	break;

    case 'o':
    case 'O':
	hazPerspectiva=0;
	reshape(400,400);
	break;

	case 'Q':
    case 'q':
		anguloX[articulacion]++;
	break;
	
	case 'A':
    case 'a':
		anguloX[articulacion]--;
	break;
	
	case 'W':
    case 'w':
		anguloY[articulacion]++;
	break;
	
	case 'S':
    case 's':
		anguloY[articulacion]--;
	break;
	
	case 'E':
    case 'e':
		anguloZ[articulacion]++;
	break;
	
	case 'D':
    case 'd':
		anguloZ[articulacion]--;
	break;
	
	/*--------------*/
	
	case '0':
		articulacion=0;
	break;
	
	case '1':
		articulacion=1;
	break;
	
	case '2':
		articulacion=2;
	break;
	
	case '3':
		articulacion=3;
	break;
	
	case '4':
		articulacion=4;
	break;
	
	case '5':
		articulacion=5;
	break;
	
	case '6':
		articulacion=6;
	break;
	
	case '7':
		articulacion=7;
	break;
	
	case '8':
		articulacion=8;
	break;

    case 27:   // escape
	exit(0);
        break;

    }
}

int main(int argc, char **argv)
{
	int i;
	for (i=0; i<NUM_ARTICULACIONES; i++){
		anguloX[i] = 0;
		anguloY[i] = 0;
		anguloZ[i] = 0;
	}
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowPosition(100, 100);
    glutInitWindowSize(400, 400);
    glutCreateWindow("Cubo");
    init();
    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutIdleFunc(idle);
    glutKeyboardFunc(keyboard);
    glutMainLoop();
    return 0;
}
