import { Matematicas } from './matematicas.class';
export interface DatosPlano {
  ancho?: number;
  alto?: number;

  minX?: number;
  minY?: number;
  maxX?: number;
  maxY?: number;
  gruesoLinea?: number;
  colorLinea?: string;
  colorFondo?: string;
  colorPuntos?: string;
  colorTexto?: string;
  colorEjes?: string;
  mostrarCuadricula?: boolean;
  margenReal?: number;
  deltaCuadriculaX?: number;
  deltaCuadriculaY?: number;
  proporcional?: true;
}

export interface Puntos {
  x: number;
  y: number;
}

export class JpCanvas {

  canvas: any;
  ctx: any;

  colorFondo = 'rgb(230,230,230)';
  colorTexto = 'black';
  colorPuntos = 'red';
  colorLinea = 'rgb(0, 151, 153)';
  colorEjes = 'black';

  mostrarCuadricula = true;
  proporcional = false;

  gruesoLinea = 2;
  margenReal = 0.5;
  deltaCuadriculaX = 1;
  deltaCuadriculaY = 1;

  planoWx = 1024;
  planoWy = 768;
  margenX = 10;
  margenY = 10;



  // Datos del plano
  minX = 0;
  minY = 0;
  maxX = 0;
  maxY = 0;

  Wx = 0;
  Wy = 0;

  Lx = 0;
  Ly = 0;
  dx = 0;
  dy = 0;

  tempX = 0;
  tempY = 0;

  ancho = 1024;
  alto = 768;

  constructor(nombreCanvas: string) {

    // Se obtiene el elemento canvas
    this.canvas = document.getElementById(nombreCanvas);

    // Si se puede obtener el contexto, se puede graficar
    if (this.canvas.getContext) {
      this.ctx = this.canvas.getContext('2d');
    } else {
      document.write('<div class="alert alert-warning" role="alert"><h3>El Navegador no soporta canvas</h3><hr></div>');
    }

  }

  dibujarRectangulo(x1: number, y1: number, wx: number, wy: number) {
    this.ctx.fillStyle = this.colorFondo;
    this.ctx.fillRect(x1, y1, wx, wy);
  }

  realXToPx(x: number): number {
    return this.dx * ( x + Math.abs(this.minX)) + this.margenX;
  }

  realYToPx(y: number): number {
    return Math.abs(this.maxY) * this.dy - y * this.dy + this.margenY;
  }

  cambiarColorFondo(cf: string) {
    this.colorFondo = cf;
  }

  crearLienzo(wx: number, wy: number) {
    this.canvas.width = wx;
    this.canvas.height = wy;

    this.ctx.fillStyle = this.colorFondo;
    this.ctx.fillRect(0, 0, wx, wy);
  }

  trazarLinea(x1: number, y1: number, x2: number, y2: number) {

    this.ctx.beginPath();
    this.ctx.moveTo(x1, y1);
    this.ctx.lineTo(x2, y2);
    this.ctx.stroke();
    this.ctx.closePath();
  }


  dibujarPunto(x1: number, y1: number) {

    this.ctx.beginPath();
    this.ctx.arc(x1, y1, 5, 0, 2 * Math.PI, true);
    this.ctx.fill();
  }

  graficarFuncion(puntos: Puntos[]) {

    this.tempX = puntos[0].x;
    this.tempY = puntos[0].y;
    let x1 = Math.abs(this.minX) * this.dx + this.tempX * this.dx + this.margenX;
    let y1 = Math.abs(this.maxY * this.dy) + this.margenY - this.tempY * this.dy;

    this.ctx.lineWidth = this.gruesoLinea;
    this.ctx.strokeStyle = this.colorLinea;
    this.ctx.beginPath();
    this.ctx.moveTo(x1, y1);
    for (const punto of puntos) {
      x1 = this.realXToPx(punto.x);
      y1 = this.realYToPx(punto.y);
      this.ctx.lineTo(x1, y1);
    }
    this.ctx.stroke();
    this.ctx.lineWidth = 1;

    // Dibujar los puntos
    this.ctx.fillStyle = this.colorPuntos;
    for (const punto of puntos) {
      x1 = this.realXToPx(punto.x);
      y1 = this.realYToPx(punto.y);
      this.dibujarPunto(x1, y1);
    }
  }

  crearPlano(configuracion: DatosPlano) {


    let x1 = 0;
    let y1 = 0;
    let x2 = 0;
    let y2 = 0;

    let x = 0;
    let y = 0;

    // Establecer el color de los puntos
    if (configuracion.colorPuntos !== undefined) {
      this.colorPuntos = configuracion.colorPuntos;
    }

    // Establecer el color del fondo
    if (configuracion.colorFondo !== undefined) {
      this.colorFondo = configuracion.colorFondo;
    }

    // Establecer el color de la linea
    if (configuracion.colorLinea !== undefined) {
      this.colorLinea = configuracion.colorLinea;
    }

    // Establecer el color del texto
    if (configuracion.colorTexto !== undefined) {
      this.colorTexto = configuracion.colorTexto;
    }

    // Establecer el color de los ejes
    if (configuracion.colorEjes !== undefined) {
      this.colorEjes = configuracion.colorEjes;
    }

    // Establecer grueso de la linea
    if (configuracion.gruesoLinea !== undefined) {
      this.gruesoLinea = configuracion.gruesoLinea;
    }

    // Establecer margen Real
    if (configuracion.margenReal !== undefined) {
      this.margenReal = configuracion.margenReal;
    }

    // Establecer delta cuadriculaX
    if (configuracion.deltaCuadriculaX !== undefined) {
      this.deltaCuadriculaX = configuracion.deltaCuadriculaX;
    }

    // Establecer delta cuadriculaX
    if (configuracion.deltaCuadriculaY !== undefined) {
      this.deltaCuadriculaY = configuracion.deltaCuadriculaY;
    }

    // Establecer ancho
    if (configuracion.ancho !== undefined) {
      this.ancho = configuracion.ancho;
    }

    // Establecer alto
    if (configuracion.alto !== undefined) {
      this.alto = configuracion.alto;
    }

     // Mostrar la cuadricula
    if (configuracion.mostrarCuadricula !== undefined) {
      this.mostrarCuadricula = configuracion.mostrarCuadricula;
    }

    // Mostrar la cuadricula
    if (configuracion.proporcional !== undefined) {
      this.proporcional = configuracion.proporcional;
    }

    this.Wx = this.ancho;
    this.Wy = this.alto;

    this.minX = configuracion.minX - this.margenReal;
    this.minY = configuracion.minY - this.margenReal;
    this.maxX = configuracion.maxX + this.margenReal;
    this.maxY = configuracion.maxY + this.margenReal;

    this.Lx = Math.abs(this.maxX - this.minX);
    this.Ly = Math.abs(this.maxY - this.minY);
    this.dx = (this.Wx - 2 * this.margenX) / this.Lx;
    this.dy = (this.Wy - 2 * this.margenY) / this.Ly;

    if (this.proporcional) {
      if (this.Lx > this.Ly) {
        this.dy = this.dx;
        this.minY = this.minX;
        this.maxY = this.maxX;
        this.Wy = this.Wx;
      } else {
        this.dx = this.dy;
        this.minX = this.minY;
        this.maxX = this.maxY;
        this.Wx = this.Wy;
      }
    }

    this.crearLienzo(this.Wx, this.Wy);

    // Dibujar el eje Y %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x1 = this.realXToPx(0);
    x2 = x1;
    y1 = this.margenY;
    y2 = this.Wy - this.margenY;

    this.trazarLinea(x1, y1, x2, y2);
    // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    // Dibujar el eje X %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x1 = this.margenX;
    x2 = this.Wx - this.margenX;
    y1 = this.realYToPx(0);
    y2 = y1;

    this.trazarLinea(x1, y1, x2, y2);
    // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    // Trazar la cuadricula %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    const xi = Math.round(this.minX / this.deltaCuadriculaX) * this.deltaCuadriculaX;
    const yi = Math.round(this.minY / this.deltaCuadriculaY) * this.deltaCuadriculaY;

    if (this.mostrarCuadricula) {

        this.ctx.lineWidth = 0.5;
        this.ctx.strokeStyle = 'rgba(200,200,200,0.7)';

        x = xi;
        this.ctx.fillStyle = this.colorTexto;

        while (x <= this.maxX) {
          x1 = this.realXToPx(x);
          x2 = x1;
          y1 = this.margenY;
          y2 = this.Wy - this.margenY;

          this.ctx.strokeStyle = this.colorEjes;
          // this.ctx.setLineDash([3, 3]);
          this.trazarLinea(x1, y1, x2, y2);

          x = x + this.deltaCuadriculaX;
        }

        y = yi;
        this.ctx.fillStyle = this.colorTexto;

        while (y <= this.maxY) {
          x1 = this.margenX;
          x2 = this.Wx - this.margenX;
          y1 = this.realYToPx(y);
          y2 = y1;

          this.trazarLinea(x1, y1, x2, y2);
          y = y + this.deltaCuadriculaY;
        }

    }

    // Trazar las líneas guia del eje X
    x = xi;
    let fontX = this.minX;

    while (x <= this.maxX) {
      x1 = this.realXToPx(x);
      x2 = x1;
      y1 = this.realYToPx(0) - 5;
      y2 = this.realYToPx(0) + 5;

      this.trazarLinea(x1, y1, x2, y2);
      x = x + this.deltaCuadriculaX;

      fontX = new Matematicas().Redondeo(fontX, 2);
      this.ctx.fillStyle = this.colorTexto;
      this.ctx.strokeStyle = this.colorTexto;
      this.ctx.textAlign = 'center';
      if (fontX !== 0) {
        this.ctx.fillText(fontX.toString(), x1, y1 + 20);
      }
      fontX = fontX + this.deltaCuadriculaX;
    }

    // Trazar las líneas guia del eje Y
    y = this.minY;
    let fontY = this.minY;
    this.ctx.fillStyle = this.colorTexto;

    while (y <= this.maxY) {
      x1 = this.realXToPx(0) - 5;
      x2 = this.realXToPx(0) + 5;
      y1 = this.realYToPx(y);
      y2 = y1;

      this.trazarLinea(x1, y1, x2, y2);
      y = y + this.deltaCuadriculaY;

      fontY = new Matematicas().Redondeo(fontY, 2);
      this.ctx.fillStyle = this.colorTexto;
      this.ctx.strokeStyle = this.colorTexto;
      this.ctx.textAlign = 'center';
      if (fontY !== 0) {
        this.ctx.fillText(fontY.toString(), x1 - 20, y1 - 5);
      }
      fontY = fontY + this.deltaCuadriculaY;
    }

    this.ctx.setLineDash([]);
  }






}
