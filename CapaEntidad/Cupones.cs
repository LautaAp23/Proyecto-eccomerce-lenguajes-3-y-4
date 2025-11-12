using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaEntidad
{
    public class Cupones
    {
        public int IdCupones { get; set; }
        public string Codigo_cupon { get; set; }
        public string TipoDescuento { get; set; }
        public decimal Porcentaje_desc_cup { get; set; }
        public decimal Monto_desc_cup { get; set; }
        public int Cantidad_cup{ get; set; }
        public int Stock { get; set; }

        public DateTime Fecha_Vencimiento { get; set; }
        public bool Activo { get; set; }

    }
}
