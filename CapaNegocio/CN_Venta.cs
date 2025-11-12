using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CapaDatos;
using CapaEntidad;

namespace CapaNegocio
{
    public class CN_Venta
    {
        private CD_Venta objCapaDato = new CD_Venta();
        public bool Registrar(Venta obj, DataTable DetalleVenta, out string Mensaje)
        {
            return objCapaDato.Registrar(obj, DetalleVenta, out Mensaje);
        }

        public List<DetalleVenta> ListarCompras(int idcliente)
        {
            return objCapaDato.ListarCompras(idcliente);
        }

        public List<VentaXCategorias> VentasCategorias(int anio, int mes)
        {
            return objCapaDato.VentasCategorias(anio, mes);
        }

        public List<VentaMensual> ObtenerVentasMensuales(int anio)
        {
            return objCapaDato.VentasMensuales(anio);
        }

    }
}
