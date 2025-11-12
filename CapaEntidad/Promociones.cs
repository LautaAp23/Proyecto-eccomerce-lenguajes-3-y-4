using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaEntidad
{
    public class Promociones
    {
        public int IdPromocion { get; set; }
        public string Silueta { get; set; }
        public decimal PorcentajeDescuento { get; set; }
        public DateTime FechaFin { get; set; }

        public bool Activo { get; set; }
    }
}
