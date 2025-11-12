using CapaDatos;
using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class CN_Cupones
    {
        private CD_Cupones objCapaDato = new CD_Cupones();

        public List<Cupones> Listar()
        {
            return objCapaDato.Listar();
        }


        public int Registrar(Cupones obj, out string Mensaje)
        {
            Mensaje = string.Empty;

            if (string.IsNullOrWhiteSpace(obj.Codigo_cupon))
            {
                Mensaje = "El código del cupón no puede estar vacío";
            }
            else if (string.IsNullOrWhiteSpace(obj.TipoDescuento))
            {
                Mensaje = "El tipo de descuento no puede estar vacío";
            }
            else if (obj.TipoDescuento == "PORCENTAJE" && obj.Porcentaje_desc_cup <= 0)
            {
                Mensaje = "Debe ingresar un porcentaje válido para el cupón";
            }
            else if (obj.TipoDescuento == "MONTO" && obj.Monto_desc_cup <= 0)
            {
                Mensaje = "Debe ingresar un monto fijo válido para el cupón";
            }
            else if (obj.Cantidad_cup <= 0 )
            {
                Mensaje = "Debe ingresar una cantidad mayor a cero para el cupón";
            }
            else if (obj.Fecha_Vencimiento <= DateTime.Now)
            {
                Mensaje = "La fecha de vencimiento debe ser mayor a la fecha actual";
            }

            if (string.IsNullOrEmpty(Mensaje))
            {
                return objCapaDato.Registrar(obj, out Mensaje);
            }
            else
            {
                return 0;
            }
        }


        public bool Editar(Cupones obj, out string Mensaje)
        {
            Mensaje = string.Empty;

            if (string.IsNullOrWhiteSpace(obj.Codigo_cupon))
            {
                Mensaje = "El código del cupón no puede estar vacío";
            }
            else if (string.IsNullOrWhiteSpace(obj.TipoDescuento))
            {
                Mensaje = "El tipo de descuento no puede estar vacío";
            }
            else if (obj.TipoDescuento == "PORCENTAJE" && obj.Porcentaje_desc_cup <= 0)
            {
                Mensaje = "Debe ingresar un porcentaje válido para el cupón";
            }
            else if (obj.TipoDescuento == "MONTO" && obj.Monto_desc_cup <= 0)
            {
                Mensaje = "Debe ingresar un monto fijo válido para el cupón";
            }
            else if (obj.Cantidad_cup <= 0)
            {
                Mensaje = "Debe ingresar una cantidad mayor a cero para el cupón";
            }
            else if (obj.Activo && obj.Fecha_Vencimiento <= DateTime.Now)
            {
                Mensaje = "No se puede activar un cupón con fecha de vencimiento pasada";
            }

            if (string.IsNullOrWhiteSpace(Mensaje))
            {
                return objCapaDato.Editar(obj, out Mensaje);
            }
            else
            {
                return false;
            }
        }

        public bool Eliminar(int id, out string Mensaje)
        {
            return objCapaDato.Eliminar(id, out Mensaje);
        }

        public bool ValidarCupon(string codigoCupon, out string mensaje, out decimal montoDescuento, out decimal porcentajeDescuento, out string tipoDescuento, out int IdCupones)
        {
            // Se delega a la capa de datos
            return objCapaDato.Validar(codigoCupon, out mensaje, out montoDescuento, out porcentajeDescuento, out tipoDescuento, out IdCupones);
        }

    }
}
