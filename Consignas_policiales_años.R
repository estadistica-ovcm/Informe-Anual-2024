# Limpiar todo
rm(list = ls())

# Librer�as
library(ggplot2)
library(dplyr)
library(stringr)
library(cowplot)
library(magick)
library(ggtext)

# Fuentes
library(showtext)
font_add_google("Barlow", "font")
showtext_auto()

# Crear datos
Data <- read.csv(file=paste0(dirname(rstudioapi::getActiveDocumentContext()$path),"/Datos/Consignas_policiales.csv")) %>%
  mutate(A�o = as.factor(A�o)) %>%
  group_by(A�o, Tipo) %>%
  summarise(Total = sum(Cantidad)) %>%
  mutate(Tipo = factor(Tipo, levels=c("Fija", "Ambulatoria", "Personalizada")))

# Definir colores
Colores <- c("Fija" = "#ec6489",
             "Ambulatoria" = "#f2904c",
             "Personalizada" = "#72bf90")

# Grafico 1
grafico <- ggplot(Data, aes(x=A�o, y=Total, fill=Tipo)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label=formatC(Total, big.mark=".", decimal.mark=",")), position = position_stack(vjust=1), vjust=-0.5, size=3, family="font", color="black") +
  annotate(geom="text", x=1:3, y=30000, family="font", fontface="bold", size=8,
           label=formatC((Data %>% group_by(A�o) %>% summarise(Total = sum(Total)))$Total, big.mark=".", decimal.mark=",")) +
  theme_light() +
  labs(y="Cantidad") +
  scale_fill_manual(values = Colores) +
  theme(text=element_text(family="font"),
        legend.position = "top",
        legend.justification = "right",
        legend.title = element_blank(),
        legend.text = element_text(size=12, family="font"),
        plot.title = element_text(size=20, family="font", face="bold"),
        plot.subtitle = element_text(size=15, family="font"),
        plot.caption = element_text(size=12, family="font", face="italic"),
        panel.grid = element_blank(),
        axis.text.x = element_text(size=15, margin = margin(t=10,r=0,b=5,l=0)),
        axis.text.y = element_text(size=15, margin = margin(t=0,r=10,b=0,l=5)),
        axis.title.x = element_text(size=12),
        axis.title.y = element_text(size=12))

# Guardar gr�fico
ggsave(filename="Consignas_policiales_a�os.png", path=paste0(dirname(rstudioapi::getActiveDocumentContext()$path),"/Graficos/PNG/"),
       plot=grafico, dpi=100, width=8, height=5)
ggsave(filename="Consignas_policiales_a�os.svg", path=paste0(dirname(rstudioapi::getActiveDocumentContext()$path),"/Graficos/SVG/"),
       plot=grafico, dpi=72, width=8, height=5)