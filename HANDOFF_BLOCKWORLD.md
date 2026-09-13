Bạn là Astra. Tiếp tục công việc từ phiên trước. Đừng đọc lại toàn bộ repo hoặc nghiên cứu lại phần cài đặt. Dùng các dữ kiện dưới đây làm trạng thái đã kiểm tra.

## Mục tiêu

Tiếp tục phát triển `Rootbound Sanctum B` thành dungeon voxel fantasy chi tiết cho game hack-and-slash third-person, với góc nhìn sát sau lưng nhân vật.

Giữ phong cách đã duyệt: phế tích đá cổ bị rễ chiếm, vòm gãy, cột, phù điêu, lửa vàng, nước và cây phát sáng xanh. Mỗi phòng cần có nhận diện riêng và sàn chiến đấu thoáng.

## Máy và Hermes

- Hệ điều hành: Windows 10.
- Model hiện tại: `gpt-5.6-luna`.
- Provider hiện tại: `openai-codex`.
- Hermes: `v0.21.2`.
- Project: `C:/Users/Administrator/.gemini/antigravity/scratch/goblin-viewer`.
- Hermes config: `C:/Users/Administrator/AppData/Local/hermes/config.yaml`.
- Hermes đã có `mcp_servers.blockworld`.
- Server dùng `node` và file:
  `C:/Users/Administrator/.gemini/antigravity/mcp_servers/blockworld/server.js`.
- Hermes đã bật toàn bộ 13 tool của server.
- Hermes đã quét external skills tại:
  `C:/Users/Administrator/.gemini/config/skills`.
- Không sửa hoặc xóa thư mục external skills.

## MCP blockworld đã kiểm tra

Lệnh `hermes mcp test blockworld` đã trả:

- `Connected`.
- `Tools discovered: 13`.
- `Auth: none`.

Trong session mới, kiểm tra bằng hai lệnh đọc trước:

- `mcp_blockworld_world_info`
- `mcp_blockworld_list_materials`

Tên tool theo quy tắc Hermes là `mcp_blockworld_<tool_name>`. Nếu runtime dùng tên hiển thị khác, tìm tool blockworld tương ứng.

13 tool gồm:

`world_info`, `list_materials`, `place_block`, `place_box`, `place_cylinder`, `place_cone`, `place_sphere`, `place_tube`, `mirror`, `remove_block`, `remove_box`, `clear`, `describe_world`.

Bắt buộc gọi `world_info` trước mọi build blockworld. Gọi `list_materials` trước khi chọn vật liệu. Đừng gọi `clear`, `place_*`, `mirror`, hoặc `remove_*` nếu user chưa yêu cầu một build cụ thể.

Blockworld là một world trong bộ nhớ riêng của MCP. Nó chưa tự liên kết với scene Godot. Đừng nói rằng `place_*` đã sửa map Godot nếu chưa có bước xuất hoặc tích hợp rõ ràng.

## Web viewer

- Static viewer: `http://localhost:5173/viewer/`.
- Trang này đã trả HTTP 200 với title `blockworld`.
- MCP server mở WebSocket trên port `8080`, hoặc `8081` đến `8083` nếu port trước bận.
- WebSocket chỉ hoạt động khi session Hermes đang giữ MCP server sống.
- Đừng coi HTTP 200 là bằng chứng WebSocket đang hoạt động.

## Trạng thái project

Phiên trước đã tạo art viewer cô lập tại:

`Rootbound_Sanctum/Art_Dungeon/`

Đã dựng đủ 14 phòng và 15 đường nối theo layout gốc. 13 phòng mới có art riêng:

01 Boat Landing — skiff và bến đèn.
02 Sluice Gate — bánh xe đồng và cổng nước.
03 Root Court — đảo rễ và tán cây.
04 Barracks — giường tầng, giá vũ khí và cờ cũ.
05 Ember Smithy — lò than mở, đe và quầy.
06 Hunter Cloister — tượng thợ săn và vườn đổ.
07 Quiet Sanctuary — phòng mẫu đã duyệt.
08 Flooded Archive — thư viện và sân nước.
09 Blood Vault — obelisk máu và vòng nghi lễ.
10 Sealed Spoils — hòm đồng dưới hậu cung mạ vàng.
11 Choir Hall — đàn ống và đèn treo.
12 Spore Grotto — nấm lớn và đấu trường boss.
13 Hidden Cache — hòm di vật và hốc mộ.
14 Ascent — cầu thang gấp khúc và ngưỡng sáng.

Các file nên đọc trước, nếu cần:

- `Rootbound_Sanctum/Art_Dungeon/README.md`
- `Rootbound_Sanctum/Art_Dungeon/dungeon.gd`
- `Rootbound_Sanctum/Art_Dungeon/room_art.gd`
- `Rootbound_Sanctum/Art_Dungeon/layout_grid.gd`
- `Rootbound_Sanctum/Art_Dungeon/early_rooms.gd`
- `Rootbound_Sanctum/Art_Dungeon/late_rooms.gd`
- `Rootbound_Sanctum/Art_Dungeon/test_dungeon.gd`
- `Rootbound_Sanctum/Art_Dungeon/Evidence/acceptance.json`
- `Rootbound_Sanctum/Art_Dungeon/Evidence/visual-review.json`
- `Rootbound_Sanctum/Art_Dungeon/Evidence/package-verification.json`

## Bằng chứng đã có

- 14 room IDs đã build.
- 15 links gốc đã giữ.
- 42 camera poses đã kiểm tra.
- 461 điểm trên corridor centerline đã kiểm tra floor và capsule clearance.
- 43 ảnh PNG Godot thật ở 1600 x 900.
- 39 ảnh cho 13 phòng mới.
- 3 ảnh cho phòng 07 trong viewer mới.
- 1 ảnh overview toàn layout.
- Renderer: Godot Forward+.
- GPU: NVIDIA GeForce GTX 1660 SUPER.
- 15 file gốc được hash và không đổi.
- Review ZIP đã kiểm tra 107 entry và đọc lại thành công.

Các artifact chính:

- `Rootbound_Sanctum/Art_Dungeon/Review/Gallery.html`
- `Rootbound_Sanctum/Art_Dungeon/Review/All_Rooms.png`
- `Rootbound_Sanctum/Art_Dungeon/Renders/map_overview.png`
- `Rootbound_Sanctum/Art_Dungeon/Rootbound_All_Rooms_Review.zip`
- `Rootbound_Sanctum/Art_Dungeon/Open_All_Rooms.bat`

## Giới hạn đã biết

Đây là art viewer, chưa phải gameplay build. Chưa có walking controller, mouse-look, combat, enemy encounter, shop logic, cache unlock, boss-clear state, navigation mesh, hoặc benchmark hiệu năng toàn dungeon.

Figure đỏ chỉ là scale proxy. Không coi nó là player character production.

Kiểm tra corridor là kiểm tra mẫu, không chứng minh mọi vị trí trong mọi phòng đều đi dc.

## Bảo vệ công việc song song

User đang có thay đổi nhân vật song song. Không reset, không checkout, không clean working tree, và không sửa các file character.

Không sửa các file map gốc hoặc scene gốc nếu user chưa yêu cầu. Art mới phải nằm trong `Rootbound_Sanctum/Art_Dungeon/`.

Working tree có thay đổi và file test map gốc bị xóa từ công việc song song. Không tự khôi phục hoặc xóa thêm. Phiên trước đã chạy một bản test map gốc đọc từ Git revision `54f69f37535ba2d900c90a1ba375b3a81ac085ad`; test đó pass.

## Cách tiếp tục

Trước hết, xác nhận trong session mới rằng hai tool đọc blockworld hoạt động. Sau đó hỏi user muốn dùng blockworld để dựng asset voxel riêng, hay muốn nối asset đó vào art viewer Godot.

Nếu user yêu cầu build bằng blockworld, nói rõ tọa độ, scale, vật liệu và world đích trước khi gọi tool. Dùng primitive lớn trước, detail sau. Giữ palette khoảng 4 đến 6 vật liệu. Không đặt từng block cho hình lớn.

Nếu user yêu cầu sửa dungeon Godot, đọc đúng các file Art_Dungeon cần thiết, viết test trước cho hành vi mới, rồi chạy Godot thật trước khi báo xong. Không dùng blockworld như thể nó tự sửa scene Godot.

Khi báo kết quả, phân biệt rõ: MCP đã kết nối, skill đã nạp, blockworld world đã thay đổi, và Godot project đã thay đổi. Không gộp bốn việc này thành một claim.
