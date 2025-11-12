using CapaEntidad;
using CapaNegocio;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using System.Web.Services.Description;

using CapaEntidad.Paypal;
using System.Net.Mail;
using System.Net;
using System.Xml.Linq;
using CapaPresentacionTienda.Filter;



namespace CapaPresentacionTienda.Controllers
{
    public class TiendaController : Controller
    {
        // GET: Tienda
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult DetalleProducto(int idproducto = 0)
        {
            Producto oProducto = new Producto();
            bool conversion;

            oProducto = new CN_Producto().Listar().Where(p => p.IdProducto == idproducto).FirstOrDefault();


            if (oProducto != null)
            {
                oProducto.Base64 = CN_Recursos.ConvertirBase64(Path.Combine(oProducto.RutaImagen, oProducto.NombreImagen), out conversion);
                oProducto.Extension = Path.GetExtension(oProducto.NombreImagen);
            }

            return View(oProducto);
        }


        [HttpPost]
        public JsonResult ListarProducto(string silueta)
        {
            List<Producto> lista = new List<Producto>();

            bool conversion;

            lista = new CN_Producto().Listar().Select(p => new Producto()
            {
                IdProducto = p.IdProducto,
                Nombre = p.Nombre,
                Descripcion = p.Descripcion,
                Silueta = p.Silueta,
                Precio = p.Precio,
                Stock = p.Stock,
                RutaImagen = p.RutaImagen,
                Base64 = CN_Recursos.ConvertirBase64(Path.Combine(p.RutaImagen, p.NombreImagen), out conversion),
                Extension = Path.GetExtension(p.NombreImagen),
                Activo = p.Activo,
                Promo = p.Promo,
                PorcentajeDescuento = p.PorcentajeDescuento
            }).Where(p =>
                p.Silueta == (silueta == "Todos" ? p.Silueta : silueta) &&
                p.Stock > 0 && p.Activo == true
                ).ToList();

            var jsonresult = Json(new { data = lista }, JsonRequestBehavior.AllowGet);
            jsonresult.MaxJsonLength = int.MaxValue;
            return jsonresult;
        }

        [HttpPost]
        public JsonResult AgregarCarrito(int idproducto)
        {
            int idcliente = ((Cliente)Session["Cliente"]).IdCliente;

            bool existe = new CN_Carrito().ExisteCarrito(idcliente, idproducto);

            bool respuesta = false;

            string mensaje = string.Empty;

            if (existe)
            {
                mensaje = "El producto ya existe en el carrito";
            }
            else
            {
                respuesta = new CN_Carrito().OperacionCarrito(idcliente, idproducto, true, out mensaje);
            }

            return Json(new { respuesta = respuesta, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult CantidadEnCarrito()
        {
            int idcliente = ((Cliente)Session["Cliente"]).IdCliente;
            int cantidad = new CN_Carrito().CantidadEnCarrito(idcliente);
            return Json(new { cantidad = cantidad }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public JsonResult ListarProductosCarrito()
        {
            int idcliente = ((Cliente)Session["Cliente"]).IdCliente;

            List<Carrito> oLista = new List<Carrito>();

            bool conversion;

            oLista = new CN_Carrito().ListarProducto(idcliente).Select(oc => new Carrito()
            {
                oProducto = new Producto()
                {
                    IdProducto = oc.oProducto.IdProducto,
                    Nombre = oc.oProducto.Nombre,
                    Precio = oc.oProducto.Precio,
                    RutaImagen = oc.oProducto.RutaImagen,
                    Base64 = CN_Recursos.ConvertirBase64(Path.Combine(oc.oProducto.RutaImagen, oc.oProducto.NombreImagen), out conversion),
                    Extension = Path.GetExtension(oc.oProducto.NombreImagen)
                },
                Cantidad = oc.Cantidad
            }).ToList();

            return Json(new { data = oLista }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult OperacionCarrito(int idproducto, bool sumar)
        {
            int idcliente = ((Cliente)Session["Cliente"]).IdCliente;

            bool respuesta = false;

            string mensaje = string.Empty;


            respuesta = new CN_Carrito().OperacionCarrito(idcliente, idproducto, sumar, out mensaje);


            return Json(new { respuesta = respuesta, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult EliminarCarrito(int idproducto)
        {
            int idcliente = ((Cliente)Session["Cliente"]).IdCliente;

            bool respuesta = false;

            string mensaje = string.Empty;

            respuesta = new CN_Carrito().EliminarCarrito(idcliente, idproducto);

            return Json(new { respuesta = respuesta, mensaje = mensaje }, JsonRequestBehavior.AllowGet);

        }

        [ValidarSession]
        [Authorize]
        public ActionResult Carrito()
        {
            return View();
        }


        [HttpPost]
        public JsonResult ValidarCupon(string codigo)
        {
            string mensaje;
            decimal montoDescuento;
            decimal porcentajeDescuento;
            string tipoDescuento;
            int IdCupones;

            bool esValido = new CN_Cupones().ValidarCupon(codigo, out mensaje, out montoDescuento, out porcentajeDescuento, out tipoDescuento, out IdCupones);

            if (esValido)
            {
                // Guardar en Session
                Session["Cupon_Id"] = IdCupones;
                Session["Cupon_Tipo"] = tipoDescuento;
                Session["Cupon_Monto"] = montoDescuento;
                Session["Cupon_Porcentaje"] = porcentajeDescuento;
            }
            else
            {
                // Limpiar por si había uno anterior
                Session.Remove("Cupon_Id");
                Session.Remove("Cupon_Tipo");
                Session.Remove("Cupon_Monto");
                Session.Remove("Cupon_Porcentaje");
            }

            return Json(new
            {
                esValido = esValido,
                mensaje = mensaje,
                montoDescuento = montoDescuento,
                porcentajeDescuento = porcentajeDescuento,
                tipoDescuento = tipoDescuento,
                IdCupones = IdCupones
            }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public async Task<JsonResult> ProcesarPago(List<Carrito> oListaCarrito, Venta oVenta)
        {
            decimal total = 0;

            DataTable detalle_venta = new DataTable();
            detalle_venta.Locale = new CultureInfo("es-PE");
            detalle_venta.Columns.Add("IdProducto", typeof(string));
            detalle_venta.Columns.Add("Cantidad", typeof(int));
            detalle_venta.Columns.Add("Total", typeof(decimal));

            List<Item> oListaItem = new List<Item>();

            // Calcular subtotal sin descuento
            foreach (Carrito oCarrito in oListaCarrito)
            {
                decimal subtotal = oCarrito.Cantidad * oCarrito.oProducto.Precio;
                total += subtotal;

                oListaItem.Add(new Item()
                {
                    name = oCarrito.oProducto.Nombre,
                    quantity = oCarrito.Cantidad.ToString(),
                    unit_amount = new UnitAmount()
                    {
                        currency_code = "USD",
                        value = oCarrito.oProducto.Precio.ToString("G", new CultureInfo("es-PE"))
                    }
                });

                detalle_venta.Rows.Add(new object[]
                {
            oCarrito.oProducto.IdProducto,
            oCarrito.Cantidad,
            subtotal
                });
            }

            decimal totalSinDescuento = total;
            decimal descuentoAplicado = 0;

            if (Session["Cupon_Id"] != null)
            {
                oVenta.IdCupones = (int)Session["Cupon_Id"];

                string tipo = Session["Cupon_Tipo"].ToString();

                if (tipo == "MONTO")
                {
                    descuentoAplicado = Convert.ToDecimal(Session["Cupon_Monto"]);
                }
                else if (tipo == "PORCENTAJE")
                {
                    decimal porcentaje = Convert.ToDecimal(Session["Cupon_Porcentaje"]);
                    descuentoAplicado = totalSinDescuento * (porcentaje / 100);
                }

                total = Math.Max(totalSinDescuento - descuentoAplicado, 0);


                Session.Remove("Cupon_Id");
                Session.Remove("Cupon_Tipo");
                Session.Remove("Cupon_Monto");
                Session.Remove("Cupon_Porcentaje");
            }
            else
            {
                oVenta.IdCupones = null;
            }

            oVenta.MontoTotal = total;
            oVenta.IdCliente = ((Cliente)Session["Cliente"]).IdCliente;

            TempData["Venta"] = oVenta;
            TempData["DetalleVenta"] = detalle_venta;

            CN_Paypal opaypal = new CN_Paypal();


            PurchaseUnit purchaseUnit = new PurchaseUnit()
            {
                amount = new Amount()
                {
                    currency_code = "USD",
                    value = total.ToString("G", new CultureInfo("es-PE")),
                    breakdown = new Breakdown()
                    {
                        item_total = new ItemTotal()
                        {
                            currency_code = "USD",
                            value = totalSinDescuento.ToString("G", new CultureInfo("es-PE"))
                        },
                        discount = new Discount()
                        {
                            currency_code = "USD",
                            value = descuentoAplicado.ToString("G", new CultureInfo("es-PE"))
                        }
                    }
                },
                description = "Compra de articulo de mi tienda",
                items = oListaItem
            };

            Checkout_Order oCheckOutOrder = new Checkout_Order()
            {
                intent = "CAPTURE",
                purchase_units = new List<PurchaseUnit> { purchaseUnit },
                application_context = new ApplicationContext()
                {
                    brand_name = "MiTienda.com",
                    landing_page = "NO_PREFERENCE",
                    user_action = "PAY_NOW",
                    return_url = "https://localhost:44363/Tienda/PagoEfectuado",
                    cancel_url = "https://localhost:44363/Tienda/Carrito"
                }
            };

            Response_Paypal<Response_Checkout> response_paypal = await opaypal.CrearSolicitud(oCheckOutOrder);

            return Json(response_paypal, JsonRequestBehavior.AllowGet);
        }



        [ValidarSession]
        [Authorize]
        public async Task<ActionResult> PagoEfectuado()
        {
            string token = Request.QueryString["token"];
            ViewData["Status"] = false;

            CN_Paypal opaypal = new CN_Paypal();
            Response_Paypal<Response_Capture> response_paypal = await opaypal.AprobarPago(token);

            ViewData["Status"] = response_paypal.Status;

            if (response_paypal.Status)
            {

                Venta oVenta = (Venta)TempData["Venta"];
                DataTable detalle_venta = (DataTable)TempData["DetalleVenta"];


                oVenta.IdTransaccion = response_paypal.Response.purchase_units[0].payments.captures[0].id;


                string mensaje = string.Empty;
                bool respuesta = new CN_Venta().Registrar(oVenta, detalle_venta, out mensaje);

                ViewData["IdTransaccion"] = oVenta.IdTransaccion;

                if (respuesta)
                {
                    try
                    {
                        // Enviar correo de confirmación
                        EnviarCorreo(oVenta, detalle_venta);
                    }
                    catch (Exception ex)
                    {
                        // Log de error si falla el envío de correo
                        Console.WriteLine($"Error al enviar correo: {ex.Message}");
                    }
                }
                else
                {
                    // Si hubo un error al registrar la venta, mostrarlo en la vista
                    ViewData["ErrorRegistro"] = mensaje;
                }
            }

            return View();
        }



        [ValidarSession]
        [Authorize]
        public ActionResult MisCompras()
        {
            int idcliente = ((Cliente)Session["Cliente"]).IdCliente;

            List<DetalleVenta> oLista = new List<DetalleVenta>();

            bool conversion;

            oLista = new CN_Venta().ListarCompras(idcliente).Select(oc => new DetalleVenta()
            {
                oProducto = new Producto()
                {
                    Nombre = oc.oProducto.Nombre,
                    Precio = oc.oProducto.Precio,
                    Base64 = CN_Recursos.ConvertirBase64(Path.Combine(oc.oProducto.RutaImagen, oc.oProducto.NombreImagen), out conversion),
                    Extension = Path.GetExtension(oc.oProducto.NombreImagen)
                },
                Cantidad = oc.Cantidad,
                Total = oc.Total,
                IdTransaccion = oc.IdTransaccion
            }).ToList();

            return View(oLista);
        }

        // Método para enviar el correo
        private void EnviarCorreo(Venta oVenta, DataTable detalle_venta)
        {
            string emailCliente = ((Cliente)Session["Cliente"]).Correo;
            string asunto = "Confirmación de tu compra - New era.com";
            string cuerpo = GenerarCuerpoCorreo(oVenta, detalle_venta);

            using (MailMessage correo = new MailMessage())
            {
                correo.From = new MailAddress("apolauty@gmail.com", "NewEra.com");
                correo.To.Add(emailCliente);
                correo.Subject = asunto;
                correo.Body = cuerpo;
                correo.IsBodyHtml = true;

                using (SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587))
                {
                    smtp.Credentials = new NetworkCredential("apolauty@gmail.com", "bhddbqjmszfddbtz");
                    smtp.EnableSsl = true;
                    smtp.Send(correo);
                }
            }
        }

        // Generar el cuerpo del correo
        private string GenerarCuerpoCorreo(Venta oVenta, DataTable detalle_venta)
        {
            string cuerpo = $@"
        <html>
        <head>
            <style>
                body {{
                    font-family: Arial, sans-serif;
                    margin: 0;
                    padding: 0;
                    background-color: #f9f9f9;
                    color: #333;
                }}
                h1 {{
                    color: #000000;
                    text-align: center;
                }}
                p {{
                    font-size: 16px;
                    line-height: 1.6;
                }}
                table {{
                    width: 100%;
                    border-collapse: collapse;
                    margin: 20px 0;
                    background-color: #fff;
                }}
                th, td {{
                    border: 1px solid #ddd;
                    text-align: left;
                    padding: 8px;
                }}
                th {{
                    background-color: #000000;
                    color: white;
                }}
                tr:nth-child(even) {{
                    background-color: #f2f2f2;
                }}
                .footer {{
                    text-align: center;
                    margin-top: 20px;
                    font-size: 14px;
                    color: #555;
                }}
            </style>
        </head>
        <body>
            <h1>Gracias por tu compra en NewEra.com</h1>
            <p>ID de Transacción: {oVenta.IdTransaccion}</p>
            <p>
                {(oVenta.IdCupones != 0
                    ? $"Monto Total con descuento aplicado: {oVenta.MontoTotal:C}"
                    : $"Monto Total sin descuento: {oVenta.MontoTotal:C}")}
            </p>

            <h2>Detalles de la compra:</h2>
            <table>
                <thead>
                    <tr>
                        <th>Producto</th>
                        <th>Cantidad</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>";

            foreach (DataRow row in detalle_venta.Rows)
            {
                int idProducto = Convert.ToInt32(row["IdProducto"]);
                string nombreProducto = ObtenerNombreProducto(idProducto);

                cuerpo += $@"
                    <tr>
                        <td>{nombreProducto}</td>
                        <td>{row["Cantidad"]}</td>
                        <td>{Convert.ToDecimal(row["Total"]).ToString("C")}</td>
                    </tr>";
            }

            cuerpo += @"
                </tbody>
            </table>
            <p>¡Esperamos que disfrutes tu compra!</p>
            <div class='footer'>
                © 2024 NewEra.com. Todos los derechos reservados.
            </div>
        </body>
        </html>";

            return cuerpo;
        }





        private string ObtenerNombreProducto(int idProducto)
        {
            Producto producto = new CN_Producto().Listar().FirstOrDefault(p => p.IdProducto == idProducto);
            return producto?.Nombre ?? "Producto no encontrado";
        }

        



    }
}

