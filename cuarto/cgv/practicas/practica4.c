/*
 * Capitulo 2
 * 'Hello World' de OpenGL
 * Aberto Jaspe Villanueva
 */

#include <GL/glut.h>
#define N_ART  11
int art = 0;
int vis = 1;
int vel = 1;
int locura = 0;
GLfloat angulox[N_ART];
GLfloat anguloy[N_ART];
GLfloat anguloz[N_ART];
GLint ancho = 500;
GLint alto = 500;
void reshape(int width, int height)
{
    glViewport(0, 0, width, height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    // gloOrtho(-1,1,-1,1,0,2)
    glOrtho(-8, 8, -8, 8, -8, 8);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}

void cintura()
{
    glRotatef(angulox[10],1.0f,0.0f,0.0f);
    glRotatef(anguloy[10],0.0f,1.0f,0.0f);
    glRotatef(anguloz[10],0.0f,0.0f,1.0f);
}
void torso()
{
    glRotatef(angulox[4],1.0f,0.0f,0.0f);
    glRotatef(anguloy[4],0.0f,1.0f,0.0f);
    glRotatef(anguloz[4],0.0f,0.0f,1.0f);
    glTranslatef(0.0f,1.4f,0.0f);
    if(locura == 1){
        angulox[4] += vel;
        anguloy[4] += vel;
        anguloz[4] += vel;
    }
}
void colocarMuslo(int lado)
{
    int pos;
    if(lado == 1){
        pos = 0;
    }else{
        pos = 2;
    }
    glRotatef(angulox[pos],1.0f,0.0f,0.0f);
    glRotatef(anguloy[pos],0.0f,1.0f,0.0f);
    glRotatef(anguloz[pos],0.0f,0.0f,1.0f);
    if(lado == 1){
        angulox[pos] += vel;
        anguloy[pos] += vel;
        anguloz[pos] += vel;
    }else{
        angulox[pos] -= vel;
        anguloy[pos] -= vel;
        anguloz[pos] -= vel;
    }
    if(locura == 1){
        angulox[pos] += vel;
        anguloy[pos] += vel;
        anguloz[pos] += vel;
    }
}

void colocarPierna(int lado)
{
    int pos;
    if(lado == 1){
        pos = 1;
    }else{
        pos = 3;
    }
    glRotatef(angulox[pos],1.0f,0.0f,0.0f);
    glRotatef(anguloy[pos],0.0f,1.0f,0.0f);
    glRotatef(anguloz[pos],0.0f,0.0f,1.0f);
    if(locura == 1){
        angulox[pos] += vel;
        anguloy[pos] += vel;
        anguloz[pos] += vel;
    }
}

void pierna(int pos)
{
    cintura();
    //esfera muslo
    glTranslatef(pos*0.8f,-1.0f,0.0f);
    glColor3f(1.0f,1.0f,1.0f);
    if(vis == 1)
    	glutSolidSphere(0.5,40,40);
    else
        glutWireSphere(0.5,20,20);
    //muslo
    glColor3f(1,0,0);
    colocarMuslo(pos);
    glPushMatrix();
    glScalef(1.0f,2.0f,1.0f);
    glTranslatef(0.0f,-0.7f,0.0f);
	if(vis == 1)
        glutSolidCube(1);
    else
        glutWireCube(1);
    //Segunda esfera (rodilla)
    glPopMatrix();
    glTranslatef(0,-2.7f,0.0f);
    glColor3f(1.0f,1.0f,1.0f);
    if(vis == 1)
    	glutSolidSphere(0.5,40,40);
    else
        glutWireSphere(0.5,20,20);
    //segundo cubo (pierna)
    colocarPierna(pos);
    glPushMatrix();
    glScalef(1.0f,1.5f,1.0f);
    glTranslatef(0.0f,-0.7f,0.0f);
    glColor3f(1,0,0);
	if(vis == 1)
        glutSolidCube(1);
    else
        glutWireCube(1);
    glPopMatrix();
    glColor3f(1.0f,1.0f,1.0f);
    glTranslatef(0.0f,-2.0f,0.0f);
    glPushMatrix();
    glScalef(1.5f,1.0f,2.0f);
	if(vis == 1)
        glutSolidCube(1);
    else
        glutWireCube(1);
    glPopMatrix();
}

void colocarBrazo(int lado)
{
    int pos;
    if(lado == 1){
        pos = 5;
    }else{
        pos = 6;
    }
    glRotatef(angulox[pos],1.0f,0.0f,0.0f);
    glRotatef(anguloy[pos],0.0f,1.0f,0.0f);
    glRotatef(anguloz[pos],0.0f,0.0f,1.0f);
    if(locura == 1){
        angulox[pos] += vel;
        anguloy[pos] += vel;
        anguloz[pos] += vel;
    }
}

void colocarAnte(int lado)
{
    int pos;
    if(lado == 1){
        pos = 7;
    }else{
        pos = 8;
    }
    glRotatef(angulox[pos],1.0f,0.0f,0.0f);
    glRotatef(anguloy[pos],0.0f,1.0f,0.0f);
    glRotatef(anguloz[pos],0.0f,0.0f,1.0f);
    if(locura == 1){
        angulox[pos] += vel;
        anguloy[pos] += vel;
        anguloz[pos] += vel;
    }
}

void brazo(int pos)
{
    torso();
    //esfera hombro
    glTranslatef(pos*1.5f,1.5f,0.0f);
    glColor3f(1.0f,1.0f,1.0f);
    if(vis == 1)
    	glutSolidSphere(0.5,40,40);
    else
        glutWireSphere(0.5,20,20);
    //cubo brazo
    glColor3f(1,0,0);
    colocarBrazo(pos);
    glPushMatrix();
    glScalef(1.0f,1.3f,1.0f);
    glTranslatef(0.0f,-0.7f,0.0f);
	if(vis == 1)
        glutSolidCube(1);
    else
        glutWireCube(1);
    //codo
    glPopMatrix();
    glColor3f(1.0f,1.0f,1.0f);
    glTranslatef(0.0f,-2.0f,0.0f);
    if(vis == 1)
    	glutSolidSphere(0.5,40,40);
    else
        glutWireSphere(0.5,20,20);
    //antebrazo
    glColor3f(1,0,0);
    colocarAnte(pos);
    glPushMatrix();
    glScalef(1.0,1.2f,1.0f);
    glTranslatef(0.0f,-0.8f,0.0f);
	if(vis == 1)
        glutSolidCube(1);
    else
        glutWireCube(1);
    glPopMatrix();
}

void cabeza(){
    torso();
    glColor3f(1.0f,1.0f,1.0f);
    glRotatef(angulox[9],1.0f,0.0f,0.0f);
    glRotatef(anguloy[9],0.0f,1.0f,0.0f);
    glRotatef(anguloz[9],0.0f,0.0f,1.0f);
    glTranslatef(0.0f,3.0f,0.0f);
}

void display()
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    glColor3f(1.0f,1.0f,1.0f);
    glLoadIdentity();
    //Cintura
    glColor3f(1,0,0);
    cintura();
	if(vis == 1)
        glutSolidCube(1.2f);
    else
        glutWireCube(1.2f);
    //abdomen
    glLoadIdentity();
    glColor3f(1.0f,1.0f,1.0f);
    glTranslatef(0.0f,1.0f,0.0f);
    if(vis == 1)
    	glutSolidSphere(0.7,40,40);
    else
        glutWireSphere(0.7,20,20);
    //torso
    glColor3f(1.0f,0,0);
    torso();
	if(vis == 1)
        glutSolidCube(2);
    else
        glutWireCube(2);
    //brazos
    glLoadIdentity();
    brazo(1);
    glLoadIdentity();
    brazo(-1);
    //cabeza
    glLoadIdentity();
    cabeza();
    if(vis == 1)
    	glutSolidSphere(1.0,40,40);
    else
        glutWireSphere(1.0,20,20);
    //piernas
    glLoadIdentity();
    pierna(1);
    glLoadIdentity();
    pierna(-1);
    glFlush();
    glutSwapBuffers();
}


void keyboard(unsigned char key, int x, int y)
{
    switch(key)
    {
    case 'q':
    case 'Q':
    //aumentar grados x
    angulox[art]++;
    break;
    case 'a':
    case 'A':
    //disminuir grados x
    angulox[art]--;
    break;
    case 'w':
    case 'W':
    //aumentar grados y
    anguloy[art]++;
    break;
    case 's':
    case 'S':
    //disminuir grados y
    anguloy[art]--;
    break;
    case 'e':
    case 'E':
    //aumentar grados z
    anguloz[art]++;
    break;
    case 'd':
    case 'D':
    //disminuir grados z
    anguloz[art]--;
    break;
    case 'l':
    case 'L':
        if(locura == 0)
        locura = 1;
        else
        locura = 0;
        break;
    case 27:
        exit(0);
        break;
    case '0': //muslo iz
        art = 0;
        break;
    case '1': //pierna iz
        art = 1;
        break;
    case '2': //muslo der
        art = 2;
        break;
    case '3': //pierna der
        art = 3;
        break;
    case '4': //torso
        art = 4;
        break;
    case '5': //brazo iz
        art = 5;
        break;
    case '6': //brazo der
        art = 6;
        break;
    case '7': //ante iz
        art = 7;
        break;
    case '8': //ante der
        art = 8;
        break;
    case '9': //cabeza
        art = 9;
        break;
    case 'c': //cintura
        art = 10;
        break;
    }
}

void idle()
{
    display();
}

void menuapp(int value)
{
    if(value == 3) vis = 1;
    if(value == 4) vis = 2;
    if(value == 5) vel = 1;
    if(value == 6) vel = 2;
    if(value == 7) vel = 3;
    if(value == 8) vel = 0;
}

void init()
{
    int submenu1;
    int submenu2;
    glClearColor(0,0,0,0);
    glEnable(GL_DEPTH_TEST);
    submenu1 = glutCreateMenu(menuapp);
    glutAddMenuEntry("Solido",3);
    glutAddMenuEntry("Alambre",4);
    submenu2 = glutCreateMenu(menuapp);
    glutAddMenuEntry("Vel 1", 5);
    glutAddMenuEntry("Vel 2", 6);
    glutAddMenuEntry("Vel 3", 7);
    glutAddMenuEntry("Parar", 8);
    glutCreateMenu(menuapp);
    glutAddSubMenu("Apariencia", submenu1);
    glutAddSubMenu("Velocidad", submenu2);
    glutAttachMenu(GLUT_RIGHT_BUTTON);
}

void processMouseActionMotion(int x, int y)
{
    angulox[5] += x;
    anguloz[5] += y;
}
void processActiveMotion(int x, int y)
{
    angulox[6] += x;
    anguloy[6] += y;
}

int main(int argc, char **argv)
{
    //inicializacion array articulaciones
    int i;
    for(i = 0; i < N_ART; i++)
    {
        angulox[i] = 0.0f;
        anguloy[i] = 0.0f;
        anguloz[i] = 0.0f;
    }
    //funciones normales
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH );
    glutInitWindowPosition(50, 50);
    glutInitWindowSize(ancho, alto);
    glutCreateWindow("Cuerpo");
    init();
    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutIdleFunc(idle);
    glutKeyboardFunc(keyboard);
    glutMotionFunc(processActiveMotion);
    glutPassiveMotionFunc(processMouseActionMotion);
    glutMainLoop();
    return 0;
}
