--Made by Noesteryo--
--https://twitter.com/NoePxl--
--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


--Function to draw a line given 2 points and a color--
local function drawline(x1, y1, x2, y2, color_)
	app.useTool{
		tool = "line",
		color = color_,
		points = {Point(x1,y1), Point(x2,y2)},
		button = MouseButton.left,
		contiguous=true,
	}
end

--Main function--
local function drawGrid(unitSize, squareSize, padding, floorSize, floorThickness, wall1, wall2, wallHeight, wallThickness, floorColor, wall1Color, wall2Color)

	local totalWidth = unitSize * (squareSize + squareSize - 2 ) * floorSize + 2 + padding*2
	if wall1 then
		totalWidth = totalWidth + wallThickness
	end
	if wall2 then
		totalWidth = totalWidth + wallThickness
	end

	local totalHeight = (squareSize + squareSize - 2 ) * floorSize + 1 + floorThickness + padding * 2
	if wall1 or wall2 then
		totalHeight = totalHeight + wallHeight * (squareSize + squareSize - 2 ) + wallThickness
	end

	local sprite = Sprite(totalWidth, totalHeight)


	local middleX = totalWidth // 2
	local middleY = totalHeight // 2


	--Making the wall2--

	if wall2 then

		local i = 0
		while i <= floorSize do

			--Draw vertical line--
			drawline(
				middleX - unitSize // 2 + 1 + unitSize * floorSize * (squareSize - 1) - i * (squareSize -1) * unitSize,
				totalHeight - 1 - padding - floorThickness - (floorSize * (squareSize - 1) + i * (squareSize -1)),
				middleX - unitSize // 2 + 1 + unitSize * floorSize * (squareSize - 1) - i * (squareSize -1) * unitSize,
				totalHeight - 1 - padding - floorThickness - (floorSize * (squareSize - 1) + i * (squareSize -1)) - (squareSize - 1) * wallHeight * 2,
				wall2Color
			)

			i = i + 1

		end

		i = 0
		while i < wallHeight do

			--Draw horizontal line--
			drawline(
				middleX - unitSize // 2 + 1 + unitSize * floorSize * (squareSize - 1),
				totalHeight - 1 - padding - floorThickness - (floorSize * (squareSize - 1) + 2 * (i + 1) * (squareSize -1)),
				middleX - unitSize // 2 - unitSize * floorSize * (squareSize - 1) + floorSize * (squareSize -1) * unitSize,
				totalHeight - 1 - padding - floorThickness - (floorSize + (i + 1)) * (squareSize -1) * 2,
				wall2Color
			)
			i = i + 1

		end

		if not wall1 then
			i = floorSize
			app.useTool{
				tool = "eraser",
				points = {Point(middleX - unitSize // 2 + 1 + unitSize * floorSize * (squareSize - 1) - i * (squareSize -1) * unitSize - 1,0), Point(middleX - unitSize // 2 + 1 + unitSize * floorSize * (squareSize - 1) - i * (squareSize -1) * unitSize - 1,totalHeight - 1)},
				button = MouseButton.left,
				contiguous=true,
			}
		end


	end


	--Making the wall1--

	if wall1 then

		local i = 0
		while i < floorSize do

			--Draw vertical line--
			drawline(
				middleX - unitSize // 2 - unitSize * floorSize * (squareSize - 1) + i * (squareSize -1) * unitSize,
				totalHeight - 1 - padding - floorThickness - (floorSize * (squareSize - 1) + i * (squareSize -1)),
				middleX - unitSize // 2 - unitSize * floorSize * (squareSize - 1) + i * (squareSize -1) * unitSize,
				totalHeight - 1 - padding - floorThickness - (floorSize * (squareSize - 1) + i * (squareSize -1)) - (squareSize - 1) * wallHeight * 2,
				wall1Color
			)


			i = i + 1
		end

		--Draw last vertical line--
		--Check if there is the second wall to offset (or not)--
		local offset = 0
		if wall2 then
			offset = 1
		end

		drawline(
			middleX - unitSize // 2 - unitSize * floorSize * (squareSize - 1) + i * (squareSize -1) * unitSize + offset,
			totalHeight - 1 - padding - floorThickness - (floorSize * (squareSize - 1) + i * (squareSize -1)),
			middleX - unitSize // 2 - unitSize * floorSize * (squareSize - 1) + i * (squareSize -1) * unitSize + offset,
			totalHeight - 1 - padding - floorThickness - (floorSize * (squareSize - 1) + i * (squareSize -1)) - (squareSize - 1) * wallHeight * 2,
			wall1Color
		)

		i = 0
		while i < wallHeight do

			--Draw horizontal line--
			drawline(
				middleX - unitSize // 2 - unitSize * floorSize * (squareSize - 1),
				totalHeight - 1 - padding - floorThickness - (floorSize * (squareSize - 1) + 2 * (i + 1) * (squareSize -1)),
				middleX - unitSize // 2 - unitSize * floorSize * (squareSize - 1) + floorSize * (squareSize -1) * unitSize + 1,
				totalHeight - 1 - padding - floorThickness - (floorSize + (i + 1)) * (squareSize -1) * 2,
				wall1Color
			)
			i = i + 1
		end

		if not wall2 then
			i = floorSize
			app.useTool{
				tool = "eraser",
				points = {Point(middleX - unitSize // 2 - unitSize * floorSize * (squareSize - 1) + i * (squareSize -1) * unitSize + 1,0), Point(middleX - unitSize // 2 - unitSize * floorSize * (squareSize - 1) + i * (squareSize -1) * unitSize,totalHeight - 1)},
				button = MouseButton.left,
				contiguous=true,
			}
		end

	end


	--Making the floor--

	local i = 0

	while i <= floorSize do

		drawline(
			middleX - unitSize // 2 - i * (squareSize -1) * unitSize,
			totalHeight - 1 - padding - floorThickness - i * (squareSize - 1),
			middleX - unitSize // 2 + 1 + unitSize * floorSize * (squareSize - 1) - i * (squareSize -1) * unitSize,
			totalHeight - 1 - padding - floorThickness - (floorSize * (squareSize - 1) + i * (squareSize -1)),
			floorColor
		)

		drawline(
			middleX - unitSize // 2 + i * (squareSize -1) * unitSize,
			totalHeight - 1 - padding - floorThickness - i * (squareSize -1),
			middleX - unitSize // 2 - unitSize * floorSize * (squareSize - 1) + i * (squareSize -1) * unitSize,
			totalHeight - 1 - padding - floorThickness - (floorSize * (squareSize - 1) + i * (squareSize -1)),
			floorColor
		)

		i = i + 1
	end

end

--Showing the dialog--
local dialog = Dialog("Isometric guidelines")
dialog  :separator{ text="Floor parameters :" }
		:slider {id="squaresize", label="Square size :", min=2, max=50, value=5}
		:slider {id="floorsize", label="Floor size (in squares) :", min=2, max=50, value=6}

		:separator{ text="Walls parameters :" }
		:check{ id="wall1",label="Left wall :",selected=true}
		:check{ id="wall2",label="Right wall :",selected=true}
		:slider {id="wallheigth", label="Wall heigth (in squares):", min=1, max=50, value=6}


		:separator{ text="Colors :" }
		:color {id="color", label="Floor color:", color = Color{r=0,g=0,b=0}}
		:color {id="wall1color", label="Left wall color:", color = Color{r=0,g=0,b=0}}
		:color {id="wall2color", label="Right wall color:", color = Color{r=0,g=0,b=0}}

		:separator{ text="miscellaneous :" }
		:slider {id="padding", label="Padding :", min=1, max=100, value=5}

		:separator()
		:button {id="ok", text="Create guidelines"}
		:show()


--Getting the data and creating the guidelines if the button is pressed--
local data = dialog.data
if data.ok then
	drawGrid(2, data.squaresize, data.padding, data.floorsize, 0, data.wall1, data.wall2, data.wallheigth, 0, data.color, data.wall1color, data.wall2color)
end
