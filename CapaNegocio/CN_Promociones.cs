using CapaDatos;
using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class CN_Promociones
    {
        private CD_Promociones objCapaDato = new CD_Promociones();

        public List<Promociones> Listar()
        {
            return objCapaDato.Listar();
        }


        public int Registrar(Promociones obj, out string Mensaje)
        {
            Mensaje = string.Empty;

            if (string.IsNullOrWhiteSpace(obj.Silueta))
            {
                Mensaje = "La silueta no puede estar vacía";
            }
            else if (obj.PorcentajeDescuento <= 0)
            {
                Mensaje = "Debe ingresar un porcentaje válido para la promo";
            }
            else if (obj.FechaFin <= DateTime.Now)
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


        public bool Editar(Promociones obj, out string Mensaje)
        {
            Mensaje = string.Empty;

            if (string.IsNullOrWhiteSpace(obj.Silueta))
            {
                Mensaje = "La silueta no puede estar vacía";
            }
            else if (obj.PorcentajeDescuento <= 0)
            {
                Mensaje = "Debe ingresar un porcentaje válido para la promo";
            }
            else if (obj.FechaFin <= DateTime.Now)
            {
                Mensaje = "La fecha de vencimiento debe ser mayor a la fecha actual";
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


    }
}
