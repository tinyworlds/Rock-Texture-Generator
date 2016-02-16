; Script to generate rock textures
; by Rick Hoppmann (www.tinyworlds.org)
; licensed as CC0/Public Domain

; REQUIRES THE PLUGIN PLUG-IN-NORMALMAP
; http://registry.gimp.org/node/69

(define (rock-tex   size
					color)

(let* ((image 0) (layer1 0) (layer2 0))

; create a new IMAGE with SIZE
(set! image (car (gimp-image-new size size 0)))

; initialize and create LAYER1 and LAYER2
(set! layer1 (car (gimp-layer-new image size size RGB-IMAGE "diffuse map" 100 NORMAL-MODE))) 
(set! layer2 (car (gimp-layer-new image size size RGB-IMAGE "normal map" 100 NORMAL-MODE)))
(gimp-image-add-layer image layer1 -1)
(gimp-image-add-layer image layer2 -1)

;fill LAYER1 with COLOR
(gimp-context-set-foreground color)
(gimp-drawable-fill layer1 0)

;create noise with SEED on LAYER2
(plug-in-solid-noise 0 image layer2 TRUE FALSE 1234 14 2 4)

;create a bump-map on LAYER1 using LAYER2
(plug-in-bump-map 1 image layer1 layer2 135 45 (/ size 16) 0 0 0 0 TRUE FALSE 0)

;create noise with SEED on LAYER2
(plug-in-solid-noise 0 image layer2 TRUE FALSE 1234 14 2 4)

;create a bump-map on LAYER1 using LAYER2
(plug-in-bump-map 1 image layer1 layer2 135 45 (/ size 16) 0 0 0 0 TRUE FALSE 0)

;turn noise on LAYER2 to normal map
(plug-in-normalmap 1 image layer2 1 0 (* size 0.01) 0 0 0 0 0 0 0 0 0 layer2)

; Create and update the display
  (gimp-display-new image)
  (gimp-displays-flush)



))

(script-fu-register "rock-tex"
_"<Image>/Filters/Render/Rock-Texture"
                    "Generate Rock Texture"
                    "Generates a rock texture and normal map using perlin noise.
					Requires the GIMP normal map plugin to work."
                    "Rick Hoppmann <www.tinyworlds.org>"
                    "July the 5th, 2015"
                    ""
                    SF-ADJUSTMENT "Texture Size" '(1024 1 4096 1 50 0 1)
					SF-COLOR      "Color"         '(125 121 112)
)
