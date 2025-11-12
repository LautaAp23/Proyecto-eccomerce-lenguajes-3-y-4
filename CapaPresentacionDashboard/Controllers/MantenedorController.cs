using CapaEntidad;
using CapaNegocio;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CapaPresentacionDashboard.Controllers
{
    [Authorize]
    public class MantenedorController : Controller
    {
        // GET: Mantenedor
        public ActionResult Productos()
        {
            return View();
        }

        public ActionResult Reportes()
        {
            return View();
        }

        public ActionResult Promociones()
        {
            return View();
        }

        //PRODUCTO
        [HttpGet]
        public JsonResult ListarProducto()
        {
            List<Producto> oLista = new List<Producto>();

            oLista = new CN_Producto().Listar();

            return Json(new { data = oLista }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult GuardarProducto(string objeto, HttpPostedFileBase archivoImagen)
        {
            string mensaje = string.Empty;
            bool operacion_exitosa = true;
            bool guardar_imagen_exito = true;


            Producto oProducto = new Producto();

            oProducto = JsonConvert.DeserializeObject<Producto>(objeto);

            decimal precio;

            if (decimal.TryParse(oProducto.PrecioTexto,NumberStyles.AllowDecimalPoint,new CultureInfo("es-PE"),out precio))
            {
                oProducto.Precio = precio;

            }
            else
            {
                return Json(new { operacionExitosa = false, mensaje = "El formato del precio debe ser ##.##" },JsonRequestBehavior.AllowGet);
            }

            
            if (oProducto.IdProducto == 0)
            {
                int IdProductoGenerado = new CN_Producto().Registrar(oProducto, out mensaje);

                if(IdProductoGenerado != 0)
                {
                    oProducto.IdProducto = IdProductoGenerado;

                }else
                {
                    operacion_exitosa =false;
                }
            }
            else
            {
                operacion_exitosa = new CN_Producto().Editar(oProducto, out mensaje);
            }

            if (operacion_exitosa)
            {
                if (archivoImagen != null)
                {
                    string ruta_guardar = ConfigurationManager.AppSettings["ServidorFotos"];
                    string extension = Path.GetExtension(archivoImagen.FileName);
                    string nombre_imagen = string.Concat(oProducto.IdProducto.ToString(), extension);


                    try
                    {
                        archivoImagen.SaveAs(Path.Combine(ruta_guardar, nombre_imagen));
                    }
                    catch(Exception ex) 
                    {
                        string msg = ex.Message;
                        guardar_imagen_exito = false;
                    }

                    if (guardar_imagen_exito)
                    {
                        oProducto.RutaImagen = ruta_guardar;
                        oProducto.NombreImagen = nombre_imagen;
                        bool rspta = new CN_Producto().GuardarDatosImagen(oProducto, out mensaje);
                    }
                    else
                    {
                        mensaje = "Se guardo el producto pero hubo problemas con la imagen";
                    }

                }
            }

            return Json(new { operacionExitosa = operacion_exitosa,idGenerado = oProducto.IdProducto, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public JsonResult ImagenProducto(int id)
        {
            bool conversion;

            Producto oproducto = new CN_Producto().Listar().Where(p => p.IdProducto == id).FirstOrDefault();

            string textoBase64 = CN_Recursos.ConvertirBase64(Path.Combine(oproducto.RutaImagen, oproducto.NombreImagen), out conversion);


            return Json(new
            {

                conversion = conversion,
                textoBase64 = textoBase64,
                extension = Path.GetExtension(oproducto.NombreImagen)
            },
            JsonRequestBehavior.AllowGet
            );
        }

        [HttpPost]
        public JsonResult EliminarProducto(int id)
        {
            bool respuesta = false;
            string mensaje = string.Empty;

            respuesta = new CN_Producto().Eliminar(id, out mensaje);


            return Json(new { resultado = respuesta, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult ListarTopVendidos()
        {
            List<MasVendido> oLista = new List<MasVendido>();

            oLista = new CN_Producto().TopVendidos();

            return Json(new { data = oLista }, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult ListarTopRecaudados()
        {
            List<MasRecaudado> oLista = new List<MasRecaudado>();

            oLista = new CN_Producto().TopRecaudaciones();

            return Json(new { data = oLista }, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult ListarCupones()
        {
            List<Cupones> oLista = new List<Cupones>();

            oLista = new CN_Cupones().Listar();

            return Json(new { data = oLista }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult GuardarCupon(string objeto)
        {
            string mensaje = string.Empty;
            bool operacion_exitosa = true;
           
            Cupones oCupon = new Cupones();

            oCupon = JsonConvert.DeserializeObject<Cupones>(objeto);

            
            if (oCupon.IdCupones == 0)
            {
                int IdCuponGenerado = new CN_Cupones().Registrar(oCupon, out mensaje);

                if (IdCuponGenerado != 0)
                {
                    oCupon.IdCupones = IdCuponGenerado;

                }
                else
                {
                    operacion_exitosa = false;
                }
            }
            else
            {
                operacion_exitosa = new CN_Cupones().Editar(oCupon, out mensaje);
            }

           

            return Json(new { operacionExitosa = operacion_exitosa, idGenerado = oCupon.IdCupones, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult EliminarCupon(int id)
        {
            bool respuesta = false;
            string mensaje = string.Empty;

            respuesta = new CN_Cupones().Eliminar(id, out mensaje);


            return Json(new { resultado = respuesta, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }



        [HttpGet]
        public JsonResult VentasCategorias(int anio, int mes)
        {
            List<VentaXCategorias> oLista = new List<VentaXCategorias>();

            oLista = new CN_Venta().VentasCategorias(anio, mes);

            return Json(new { data = oLista }, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult VentasPorMes(int anio)
        {
            var lista = new CN_Venta().ObtenerVentasMensuales(anio);
            return Json(new { data = lista }, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult ListarPromociones()
        {
            List<Promociones> oLista = new List<Promociones>();

            oLista = new CN_Promociones().Listar();

            return Json(new { data = oLista }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult GuardarPromociones(string objeto)
        {
            string mensaje = string.Empty;
            bool operacion_exitosa = true;

            Promociones oPromociones = new Promociones();

            oPromociones = JsonConvert.DeserializeObject<Promociones>(objeto);


            if (oPromociones.IdPromocion == 0)
            {
                int IdCuponGenerado = new CN_Promociones().Registrar(oPromociones, out mensaje);

                if (IdCuponGenerado != 0)
                {
                    oPromociones.IdPromocion = IdCuponGenerado;

                }
                else
                {
                    operacion_exitosa = false;
                }
            }
            else
            {
                operacion_exitosa = new CN_Promociones().Editar(oPromociones, out mensaje);
            }



            return Json(new { operacionExitosa = operacion_exitosa, idGenerado = oPromociones.IdPromocion, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult EliminarPromociones(int id)
        {
            bool respuesta = false;
            string mensaje = string.Empty;

            respuesta = new CN_Promociones().Eliminar(id, out mensaje);


            return Json(new { resultado = respuesta, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }


    }


}